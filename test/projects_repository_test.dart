import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/projects_repository.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'helpers/auth_helper.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ProjectsRepository repository;
  late FakeAuthRepository fakeAuth;
  const testUid = 'fake_uid';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeAuth = FakeAuthRepository(initialUid: testUid);
    addTearDown(fakeAuth.dispose);
    repository = ProjectsRepository(fakeFirestore, uid: testUid);
  });

  group('ProjectsRepository', () {
    test('watchProjects emits empty list initially', () async {
      final projects = await repository.watchProjects().first;
      expect(projects, isEmpty);
    });

    test('addProject then watchProjects emits the project', () async {
      final project = Project(
        id: 'p1',
        goalId: 'g1',
        title: 'Project Title',
        status: ProjectStatus.active,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addProject(project);
      final projects = await repository.watchProjects().first;

      expect(projects, hasLength(1));
      expect(projects.first, equals(project));
    });

    test('updateProject changes the project title', () async {
      final project = Project(
        id: 'p1',
        goalId: 'g1',
        title: 'Old Title',
        status: ProjectStatus.active,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addProject(project);
      await repository.updateProject(project.copyWith(title: 'New Title'));

      final projects = await repository.watchProjects().first;
      expect(projects.first.title, equals('New Title'));
    });

    test('deleteProject removes the project', () async {
      final project = Project(
        id: 'p1',
        goalId: 'g1',
        title: 'Project Title',
        status: ProjectStatus.active,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addProject(project);
      await repository.deleteProject(project.id);

      final projects = await repository.watchProjects().first;
      expect(projects, isEmpty);
    });

    test('watchProjectsByGoal filters correctly', () async {
      final projectA = Project(
        id: 'p1',
        goalId: 'g1',
        title: 'Project A',
        status: ProjectStatus.active,
        createdAt: DateTime.now().toUtc(),
      );
      final projectB = Project(
        id: 'p2',
        goalId: 'g2',
        title: 'Project B',
        status: ProjectStatus.active,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addProject(projectA);
      await repository.addProject(projectB);

      final g1Projects = await repository.watchProjectsByGoal('g1').first;
      expect(g1Projects, hasLength(1));
      expect(g1Projects.first.id, equals('p1'));
    });

    group('Providers', () {
      test('projectsStreamProvider emits values from repository', () async {
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuth),
            projectsRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final subscription = container.listen(
          projectsStreamProvider,
          (prev, next) {},
        );

        final project = Project(
          id: 'p1',
          goalId: 'g1',
          title: 'Stream Test',
          status: ProjectStatus.active,
          createdAt: DateTime.now().toUtc(),
        );

        var projects = await container.read(projectsStreamProvider.future);
        expect(projects, isEmpty);

        await repository.addProject(project);

        projects = await container.read(projectsStreamProvider.future);
        expect(projects, hasLength(1));
        expect(projects.first.title, equals('Stream Test'));

        subscription.close();
      });
    });
  });
}
