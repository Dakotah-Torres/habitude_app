import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/goals_repository.dart';
import 'package:habitude/features/goals/screens/goals_list_screen.dart';
import 'package:habitude/shared/theme.dart';

void main() {
  group('GoalsListScreen', () {
    testWidgets('rendered with 3 fake goals → 3 items visible', (tester) async {
      final goals = [
        Goal(
          id: '1',
          title: 'Goal 1',
          type: GoalType.continuous,
          createdAt: DateTime.now(),
        ),
        Goal(
          id: '2',
          title: 'Goal 2',
          type: GoalType.finite,
          createdAt: DateTime.now(),
        ),
        Goal(
          id: '3',
          title: 'Goal 3',
          type: GoalType.continuous,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsStreamProvider.overrideWith((ref) => Stream.value(goals)),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const GoalsListScreen(),
          ),
        ),
      );

      await tester.pump(); // Start stream
      await tester.pump(); // Get data

      expect(find.text('Goal 1'), findsOneWidget);
      expect(find.text('Goal 2'), findsOneWidget);
      expect(find.text('Goal 3'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('rendered with 0 → empty state visible', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const GoalsListScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Start with one goal.'), findsOneWidget);
      expect(find.text('Add goal'), findsOneWidget);
    });

    testWidgets('shows loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsStreamProvider.overrideWith((ref) => const Stream.empty()),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const GoalsListScreen(),
          ),
        ),
      );

      expect(find.text('Loading goals'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
