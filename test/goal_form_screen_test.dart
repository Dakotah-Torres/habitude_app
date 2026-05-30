import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/goals_repository.dart';
import 'package:habitude/features/goals/screens/goal_form_screen.dart';
import 'package:habitude/shared/theme.dart';

class FakeGoalsRepository extends Fake implements GoalsRepository {
  Goal? lastAddedGoal;
  Goal? lastUpdatedGoal;
  bool shouldFail = false;

  @override
  Future<void> addGoal(Goal goal) async {
    if (shouldFail) throw Exception('Simulated failure');
    lastAddedGoal = goal;
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    lastUpdatedGoal = goal;
  }
}

void main() {
  late FakeGoalsRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeGoalsRepository();
  });

  group('GoalFormScreen', () {
    testWidgets(
      'fill title → tap Save → addGoal called once with correct title',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              goalsRepositoryProvider.overrideWithValue(fakeRepository),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: const GoalFormScreen(),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'New Goal Title');
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(fakeRepository.lastAddedGoal, isNotNull);
        expect(fakeRepository.lastAddedGoal!.title, equals('New Goal Title'));
      },
    );

    testWidgets('edit mode → change title → tap Save → updateGoal called', (
      tester,
    ) async {
      final initialGoal = Goal(
        id: '1',
        title: 'Old Title',
        type: GoalType.continuous,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: GoalFormScreen(initialGoal: initialGoal),
          ),
        ),
      );

      expect(find.text('Old Title'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'New Title');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(fakeRepository.lastUpdatedGoal, isNotNull);
      expect(fakeRepository.lastUpdatedGoal!.title, equals('New Title'));
    });

    testWidgets('empty title shows validation error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const GoalFormScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Add a title to save this goal.'), findsOneWidget);
      expect(fakeRepository.lastAddedGoal, isNull);
    });

    testWidgets('repository fails → show inline error message', (tester) async {
      fakeRepository.shouldFail = true;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const GoalFormScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Fail Test');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        find.text('Goal was not saved. Nothing was lost; try again.'),
        findsOneWidget,
      );
      expect(fakeRepository.lastAddedGoal, isNull);
    });
  });
}
