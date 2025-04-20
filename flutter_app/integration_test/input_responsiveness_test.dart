import 'package:flutter/material.dart';
import 'package:flutter_app/config/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_app/ui/input-responsiveness/input_responsiveness_screen.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'dart:math';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Input Responsiveness Test', () {
    testWidgets('should toggle list view, reorder items, and scroll to bottom', (
      tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: providersLocal,
          child: const MaterialApp(home: InputResponsivenessScreen()),
        ),
      );

      // Initial pump to trigger initState
      await tester.pump();

      // Wait for initial load and animations to settle
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Toggle list view 4 times at the start
      for (int i = 0; i < 4; i++) {
        final toggleButton = find.byType(TextButton).first;
        await tester.tap(toggleButton);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }

      // Verify grid is visible
      expect(find.byType(ReorderableGridView), findsOneWidget);
      final initialTiles = find.byType(Card);
      expect(initialTiles, findsWidgets);

      // Scroll to bottom with random reordering
      final gridFinder = find.byType(ReorderableGridView);
      bool canScroll = true;
      int scrollAttempts = 0;
      const maxScrollAttempts = 20;
      const bufferZone = 200.0; // Increased buffer zone

      while (canScroll && scrollAttempts < maxScrollAttempts) {
        // Perform card reordering 3 times before scrolling
        for (int i = 0; i < 3; i++) {
          // Find all visible cards in the viewport
          final cards = find.byType(Card).evaluate();
          final screenHeight = tester.binding.window.physicalSize.height;

          // Filter cards that are in the safe zone (not too close to top or bottom)
          final visibleCards =
              cards.where((element) {
                final renderObject = element.renderObject as RenderBox;
                final position = renderObject.localToGlobal(Offset.zero);
                final size = renderObject.size;
                final cardTop = position.dy;
                final cardBottom = position.dy + size.height;

                // Card must be fully within the safe zone
                return cardTop >= bufferZone &&
                    cardBottom <= screenHeight - bufferZone;
              }).toList();

          if (visibleCards.length > 2) {
            // Randomly select a card to reorder, ensuring it's not too close to edges
            final random = Random();
            final startIndex =
                random.nextInt(visibleCards.length - 2) +
                1; // Start from index 1 to avoid first card
            final firstCard = visibleCards[startIndex];
            final firstCardFinder = find.byWidget(firstCard.widget);

            // Double check source card position
            final firstCardRenderObject = firstCard.renderObject as RenderBox;
            final firstCardPosition = firstCardRenderObject.localToGlobal(
              Offset.zero,
            );
            final firstCardSize = firstCardRenderObject.size;
            final firstCardTop = firstCardPosition.dy;
            final firstCardBottom = firstCardTop + firstCardSize.height;

            if (firstCardTop >= bufferZone &&
                firstCardBottom <= screenHeight - bufferZone) {
              // Start a gesture at the center of the card
              final firstCardCenter = tester.getCenter(firstCardFinder);
              final gesture = await tester.startGesture(firstCardCenter);

              // Hold for 1 second
              await tester.pump(const Duration(seconds: 1));

              // Determine reordering pattern with safety checks
              final pattern = random.nextInt(
                4,
              ); // 0: down, 1: up, 2: right, 3: left
              int nextCardIndex;

              // Calculate next index with bounds checking
              if (pattern == 0) {
                nextCardIndex = startIndex + 1;
              } else if (pattern == 1) {
                nextCardIndex = startIndex - 1;
              } else if (pattern == 2) {
                nextCardIndex = startIndex + 3;
              } else {
                nextCardIndex = startIndex - 3;
              }

              // Ensure next index is valid and not too close to edges
              if (nextCardIndex >= 0 && nextCardIndex < visibleCards.length) {
                final nextCard = visibleCards[nextCardIndex];
                final nextCardRenderObject = nextCard.renderObject as RenderBox;
                final nextCardPosition = nextCardRenderObject.localToGlobal(
                  Offset.zero,
                );
                final nextCardSize = nextCardRenderObject.size;
                final nextCardTop = nextCardPosition.dy;
                final nextCardBottom = nextCardTop + nextCardSize.height;

                // Verify target position is safe
                if (nextCardTop >= bufferZone &&
                    nextCardBottom <= screenHeight - bufferZone) {
                  final nextCardFinder = find.byWidget(nextCard.widget);
                  final nextCardCenter = tester.getCenter(nextCardFinder);

                  // Calculate the move offset with some randomness
                  final baseOffset = nextCardCenter - firstCardCenter;
                  final randomFactor = 0.8 + random.nextDouble() * 0.4;
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
            }
          }
        }

        // Scroll down with a larger step
        await tester.fling(gridFinder, const Offset(0, -1000), 2000);
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

      // Toggle list view 3 times at the end
      for (int i = 0; i < 3; i++) {
        final toggleButton = find.byType(TextButton).first;
        await tester.tap(toggleButton);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }
    });
  });
}
