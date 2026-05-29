import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/goals/tasks_repository.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'helpers/auth_helper.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late TasksRepository repository;
  late FakeAuthRepository fakeAuth;
  const testUid = 'fake_uid';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeAuth = FakeAuthRepository(initialUid: testUid);
    addTearDown(fakeAuth.dispose);
    repository = TasksRepository(fakeFirestore, uid: testUid);
  });

  group('TasksRepository', () {
    test('watchTasks emits empty list initially', () async {
      final tasks = await repository.watchTasks().first;
      expect(tasks, isEmpty);
    });

    test('addTask then watchTasks emits the task', () async {
      final task = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Task Title',
        energyScore: 3,
        taskType: TaskType.oneTime,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addTask(task);
      final tasks = await repository.watchTasks().first;

      expect(tasks, hasLength(1));
      expect(tasks.first, equals(task));
    });

    test('updateTask changes the task title', () async {
      final task = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Old Title',
        energyScore: 3,
        taskType: TaskType.oneTime,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addTask(task);
      await repository.updateTask(task.copyWith(title: 'New Title'));

      final tasks = await repository.watchTasks().first;
      expect(tasks.first.title, equals('New Title'));
    });

    test('deleteTask removes the task', () async {
      final task = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Task Title',
        energyScore: 3,
        taskType: TaskType.oneTime,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addTask(task);
      await repository.deleteTask(task.id);

      final tasks = await repository.watchTasks().first;
      expect(tasks, isEmpty);
    });

    test('watchTasksByParent filters correctly', () async {
      final taskA = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Task A',
        energyScore: 3,
        taskType: TaskType.oneTime,
        createdAt: DateTime.now().toUtc(),
      );
      final taskB = Task(
        id: 't2',
        parentId: 'p2',
        parentType: ParentType.project,
        title: 'Task B',
        energyScore: 3,
        taskType: TaskType.oneTime,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addTask(taskA);
      await repository.addTask(taskB);

      final p1Tasks = await repository.watchTasksByParent('p1').first;
      expect(p1Tasks, hasLength(1));
      expect(p1Tasks.first.id, equals('t1'));
    });

    test('preserves weeklyQuota == null for oneTime tasks', () async {
      final task = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'One-time Task',
        energyScore: 3,
        taskType: TaskType.oneTime,
        weeklyQuota: null,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addTask(task);
      final tasks = await repository.watchTasks().first;
      expect(tasks.first.weeklyQuota, isNull);
    });

    test('preserves weeklyQuota value for recurring tasks', () async {
      final task = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Recurring Task',
        energyScore: 3,
        taskType: TaskType.recurring,
        weeklyQuota: 3,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addTask(task);
      final tasks = await repository.watchTasks().first;
      expect(tasks.first.weeklyQuota, equals(3));
    });

    group('Providers', () {
      test('tasksStreamProvider emits values from repository', () async {
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuth),
            tasksRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final subscription = container.listen(
          tasksStreamProvider,
          (prev, next) {},
        );

        final task = Task(
          id: 't1',
          parentId: 'p1',
          parentType: ParentType.project,
          title: 'Stream Test',
          energyScore: 3,
          taskType: TaskType.oneTime,
          createdAt: DateTime.now().toUtc(),
        );

        var tasks = await container.read(tasksStreamProvider.future);
        expect(tasks, isEmpty);

        await repository.addTask(task);

        tasks = await container.read(tasksStreamProvider.future);
        expect(tasks, hasLength(1));
        expect(tasks.first.title, equals('Stream Test'));

        subscription.close();
      });
    });
  });
}
