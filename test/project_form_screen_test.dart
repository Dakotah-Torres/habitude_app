import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/projects_repository.dart';
import 'package:habitude/features/goals/screens/project_form_screen.dart';
import 'package:habitude/shared/theme.dart';

class FakeProjectsRepository extends Fake implements ProjectsRepository {
  Project? lastAddedProject;
  Project? lastUpdatedProject;

  @override
  Future<void> addProject(Project project) async {
    lastAddedProject = project;
  }

  @override
  Future<void> updateProject(Project project) async {
    lastUpdatedProject = project;
  }
}

void main() {
  late FakeProjectsRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeProjectsRepository();
  });

  group('ProjectFormScreen', () {
    testWidgets('create mode → fill → save → addProject called', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ProjectFormScreen(goalId: 'g1'),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'New Project Title');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(fakeRepository.lastAddedProject, isNotNull);
      expect(
        fakeRepository.lastAddedProject!.title,
        equals('New Project Title'),
      );
      expect(fakeRepository.lastAddedProject!.goalId, equals('g1'));
    });

    testWidgets('edit mode → change status → save → updateProject called', (
      tester,
    ) async {
      final initialProject = Project(
        id: 'p1',
        goalId: 'g1',
        title: 'Old Title',
        status: ProjectStatus.active,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: ProjectFormScreen(initialProject: initialProject),
          ),
        ),
      );

      // Change status to Completed
      await tester.tap(find.text('Completed'));
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(fakeRepository.lastUpdatedProject, isNotNull);
      expect(
        fakeRepository.lastUpdatedProject!.status,
        equals(ProjectStatus.completed),
      );
    });
  });
}
