import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/goals_repository.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/projects_repository.dart';
import 'package:habitude/features/goals/screens/goal_detail_screen.dart';
import 'package:habitude/shared/theme.dart';

void main() {
  group('GoalDetailScreen', () {
    testWidgets('rendered with goal and 2 fake projects → 2 items visible', (
      tester,
    ) async {
      final goal = Goal(
        id: 'g1',
        title: 'Goal 1',
        type: GoalType.continuous,
        createdAt: DateTime.now(),
      );
      final projects = [
        Project(
          id: 'p1',
          goalId: 'g1',
          title: 'Project 1',
          status: ProjectStatus.active,
          createdAt: DateTime.now(),
        ),
        Project(
          id: 'p2',
          goalId: 'g1',
          title: 'Project 2',
          status: ProjectStatus.completed,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalStreamProvider('g1').overrideWith((ref) => Stream.value(goal)),
            projectsByGoalStreamProvider(
              'g1',
            ).overrideWith((ref) => Stream.value(projects)),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const GoalDetailScreen(goalId: 'g1'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Goal 1'), findsOneWidget);
      expect(find.text('Project 1'), findsOneWidget);
      expect(find.text('Project 2'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('shows empty state when no projects', (tester) async {
      final goal = Goal(
        id: 'g1',
        title: 'Goal 1',
        type: GoalType.continuous,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalStreamProvider('g1').overrideWith((ref) => Stream.value(goal)),
            projectsByGoalStreamProvider(
              'g1',
            ).overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const GoalDetailScreen(goalId: 'g1'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('No projects yet.'), findsOneWidget);
    });
  });
}
