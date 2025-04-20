import 'package:flutter/material.dart';
import 'package:flutter_app/config/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_app/ui/pure-performance/pure_performance_screen.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pure Performance Test', () {
    testWidgets('should load all list', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: providersLocal,
          child: const MaterialApp(home: PurePerformanceScreen()),
        ),
      );

      // Initial pump to trigger initState
      await tester.pump();

      // Wait for async operations (getItems) to complete
      await tester.pumpAndSettle();

      // Verify that ListView is present
      expect(find.byType(ListView), findsOneWidget);

      // Verify that list items are displayed
      expect(find.byType(ListTile), findsWidgets);

      // Scroll to the bottom of the list
      final listFinder = find.byType(ListView);

      // Keep scrolling until we can't scroll anymore
      bool canScroll = true;
      int consecutiveFailures = 0;
      double lastScrollPosition = 0;

      while (canScroll && consecutiveFailures < 3) {
        try {
          // Increase scroll offset for faster scrolling
          await tester.fling(listFinder, const Offset(0, -1000), 5000);
          await tester.pump(); // Start the scroll

          // Wait for scroll to settle
          await tester.pump(const Duration(milliseconds: 200));

          // Get scroll position
          final ScrollableState scrollState = tester.state(
            find.byType(Scrollable),
          );
          final double currentPosition = scrollState.position.pixels;

          // If we haven't moved or can't scroll further
          if ((currentPosition - lastScrollPosition).abs() < 1) {
            consecutiveFailures++;
          } else {
            consecutiveFailures = 0;
            lastScrollPosition = currentPosition;
          }

          // Check if we're at the bottom
          if (scrollState.position.atEdge && scrollState.position.pixels > 0) {
            canScroll = false;
          }
        } catch (e) {
          consecutiveFailures++;
        }
      }

      // Verify we're at the bottom
      final ScrollableState finalScrollState = tester.state(
        find.byType(Scrollable),
      );
      expect(finalScrollState.position.atEdge, true);
      expect(finalScrollState.position.pixels > 0, true);
    });
  });
}
