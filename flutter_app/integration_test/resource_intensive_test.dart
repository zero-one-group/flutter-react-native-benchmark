import 'package:flutter/material.dart';
import 'package:flutter_app/config/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_app/ui/resource-intensive/resource_intensive_screen.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'dart:math';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Resource Intensive Test', () {
    testWidgets('should scroll from top to bottom', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: providersLocal,
          child: const MaterialApp(home: ResourceIntensiveScreen()),
        ),
      );

      // Initial pump to trigger initState
      await tester.pump();

      // Wait for initial load and animations to settle
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify initial state
      expect(find.byType(ReorderableGridView), findsOneWidget);
      final initialTiles = find.byType(Card);
      expect(initialTiles, findsWidgets);

      // Scroll to bottom
      final gridFinder = find.byType(ReorderableGridView);
      bool canScroll = true;
      int scrollAttempts = 0;
      const maxScrollAttempts = 20;

      while (canScroll && scrollAttempts < maxScrollAttempts) {
        // Perform card reordering 3 times before scrolling
        for (int i = 0; i < 3; i++) {
          // Find all visible cards in the viewport
          final cards = find.byType(Card).evaluate();
          final screenHeight = tester.binding.window.physicalSize.height;
          final bufferZone = 150.0; // Increased buffer zone

          final visibleCards =
              cards.where((element) {
                final renderObject = element.renderObject as RenderBox;
                final position = renderObject.localToGlobal(Offset.zero);
                final size = renderObject.size;
                // Skip cards too close to the top and bottom
                return position.dy >= bufferZone &&
                    position.dy + size.height <= screenHeight - bufferZone;
              }).toList();

          if (visibleCards.length > 2) {
            // Randomly select a card to reorder
            final random = Random();
            final startIndex = random.nextInt(visibleCards.length - 2) + 2;
            final firstCard = visibleCards[startIndex];
            final firstCardFinder = find.byWidget(firstCard.widget);

            // Check if source card is in safe zone
            final firstCardRenderObject = firstCard.renderObject as RenderBox;
            final firstCardPosition = firstCardRenderObject.localToGlobal(
              Offset.zero,
            );
            final firstCardBottom =
                firstCardPosition.dy + firstCardRenderObject.size.height;

            if (firstCardPosition.dy >= bufferZone &&
                firstCardBottom <= screenHeight - bufferZone) {
              // Start a gesture at the center of the card
              final firstCardCenter = tester.getCenter(firstCardFinder);
              final gesture = await tester.startGesture(firstCardCenter);

              // Hold for 1 second
              await tester.pump(const Duration(seconds: 1));

              // Determine reordering pattern
              final pattern = random.nextInt(
                4,
              ); // 0: down, 1: up, 2: right, 3: left
              final nextCardIndex =
                  pattern == 0
                      ? startIndex + 1
                      : pattern == 1
                      ? startIndex - 1
                      : pattern == 2
                      ? startIndex + 3
                      : startIndex - 3;

              // Check if target position is valid and in safe zone
              if (nextCardIndex >= 0 && nextCardIndex < visibleCards.length) {
                final nextCard = visibleCards[nextCardIndex];
                final nextCardRenderObject = nextCard.renderObject as RenderBox;
                final nextCardPosition = nextCardRenderObject.localToGlobal(
                  Offset.zero,
                );
                final nextCardBottom =
                    nextCardPosition.dy + nextCardRenderObject.size.height;

                if (nextCardPosition.dy >= bufferZone &&
                    nextCardBottom <= screenHeight - bufferZone) {
                  final nextCardFinder = find.byWidget(nextCard.widget);
                  final nextCardCenter = tester.getCenter(nextCardFinder);

                  // Calculate the move offset with some randomness
                  final baseOffset = nextCardCenter - firstCardCenter;
                  final randomFactor =
                      0.8 + random.nextDouble() * 0.4; // 0.8 to 1.2
                  final moveOffset = Offset(
                    baseOffset.dx * randomFactor,
                    baseOffset.dy * randomFactor,
                  );

                  // Move to the next position without releasing
                  await gesture.moveBy(moveOffset);
                  await tester.pumpAndSettle(const Duration(milliseconds: 500));

                  // Release the gesture
                  await gesture.up();
                  await tester.pumpAndSettle(const Duration(milliseconds: 500));
                } else {
                  // If target is too close to edge, just release
                  await gesture.up();
                  await tester.pumpAndSettle(const Duration(milliseconds: 500));
                }
              } else {
                // If target position is invalid, just release
                await gesture.up();
                await tester.pumpAndSettle(const Duration(milliseconds: 500));
              }
            } else {
              // Skip this iteration if source card is too close to edge
              continue;
            }
          }
        }

        // Scroll down with a larger step and faster speed
        await tester.fling(gridFinder, const Offset(0, -1000), 2000);
        // Give more time for animations to settle after each scroll
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Check if we can still scroll
        final scrollable = tester.widget<Scrollable>(find.byType(Scrollable));
        final scrollController = scrollable.controller;
        if (scrollController != null) {
          if (scrollController.position.atEdge &&
              scrollController.position.pixels > 0) {
            canScroll = false;
          }
        }
        scrollAttempts++;
      }

      // Verify we reached the bottom
      final finalScrollable = tester.widget<Scrollable>(
        find.byType(Scrollable),
      );
      final finalScrollController = finalScrollable.controller;
      if (finalScrollController != null) {
        expect(finalScrollController.position.atEdge, true);
        expect(finalScrollController.position.pixels > 0, true);
      }
    });
  });
}
