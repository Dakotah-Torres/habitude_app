import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';
import 'package:habitude/features/triage/brain_dump_repository.dart';
import 'package:habitude/features/triage/screens/triage_funnel_screen.dart';
import 'package:habitude/features/triage/triage_service.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/theme.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FakeBrainDumpRepository extends BrainDumpRepository {
  FakeBrainDumpRepository() : super(FakeFirebaseFirestore(), uid: 'test');
  
  BrainDumpItem? updatedItem;
  String? deletedId;

  @override
  Future<void> updateItem(BrainDumpItem item) async {
    updatedItem = item;
  }

  @override
  Future<void> deleteItem(String id) async {
    deletedId = id;
  }
}

class FakeTaskCompletionRepository extends TaskCompletionRepository {
  FakeTaskCompletionRepository() : super(FakeFirebaseFirestore(), uid: 'test');
  
  bool addCompletionCalled = false;

  @override
  Future<void> addCompletion(dynamic c) async {
    addCompletionCalled = true;
  }
}

void main() {
  group('TriageFunnelScreen', () {
    final brainDumpItem = BrainDumpItem(
      id: 'bd1',
      text: 'Thought 1',
      createdAt: DateTime.now().toUtc(),
    );

    final recurringTask = Task(
      id: 'rt1',
      parentId: 'p1',
      parentType: ParentType.project,
      title: 'Recurring Task',
      energyScore: 20,
      taskType: TaskType.recurring,
      weeklyQuota: 3,
      createdAt: DateTime.now().toUtc(),
    );

    testWidgets('renders cards sequentially and shows completion state', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();
      final fakeCompletionRepo = FakeTaskCompletionRepository();
      final queue = [
        TriageItem.brainDump(brainDumpItem),
        TriageItem.task(recurringTask, 1),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserIdProvider.overrideWithValue('test'),
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            taskCompletionRepositoryProvider.overrideWithValue(fakeCompletionRepo),
            triageQueueProvider.overrideWithValue(queue),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TriageFunnelScreen(),
          ),
        ),
      );

      // Card 1
      expect(find.text('Thought 1'), findsOneWidget);
      expect(find.text('Card 1 of 2'), findsOneWidget);
      
      await tester.tap(find.byKey(const Key('triage_do_today')));
      await tester.pumpAndSettle();

      // Card 2
      expect(find.text('Recurring Task'), findsOneWidget);
      expect(find.text('Card 2 of 2'), findsOneWidget);

      await tester.tap(find.byKey(const Key('triage_do_today')));
      await tester.pumpAndSettle();

      // Completion
      expect(find.text('All caught up!'), findsOneWidget);
    });

    testWidgets('Do Today on BrainDumpItem updates item with scheduledForDate', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();
      final queue = [TriageItem.brainDump(brainDumpItem)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserIdProvider.overrideWithValue('test'),
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            triageQueueProvider.overrideWithValue(queue),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TriageFunnelScreen(),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('triage_do_today')));
      await tester.pumpAndSettle();

      expect(fakeRepo.updatedItem?.scheduledForDate, isNotNull);
    });

    testWidgets('Tomorrow on BrainDumpItem updates item with backloggedUntil', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();
      final queue = [TriageItem.brainDump(brainDumpItem)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserIdProvider.overrideWithValue('test'),
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            triageQueueProvider.overrideWithValue(queue),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TriageFunnelScreen(),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('triage_tomorrow')));
      await tester.pumpAndSettle();

      expect(fakeRepo.updatedItem?.backloggedUntil, isNotNull);
    });

    testWidgets('Remove on BrainDumpItem deletes item', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();
      final queue = [TriageItem.brainDump(brainDumpItem)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserIdProvider.overrideWithValue('test'),
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            triageQueueProvider.overrideWithValue(queue),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TriageFunnelScreen(),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('triage_remove')));
      await tester.pumpAndSettle();

      expect(fakeRepo.deletedId, 'bd1');
    });

    testWidgets('Do Today on Task card adds completion', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();
      final fakeCompletionRepo = FakeTaskCompletionRepository();
      final queue = [TriageItem.task(recurringTask, 0)];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserIdProvider.overrideWithValue('test'),
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            taskCompletionRepositoryProvider.overrideWithValue(fakeCompletionRepo),
            triageQueueProvider.overrideWithValue(queue),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TriageFunnelScreen(),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('triage_do_today')));
      await tester.pumpAndSettle();

      expect(fakeCompletionRepo.addCompletionCalled, isTrue);
    });
   group('Triage gestures', () {
      testWidgets('swipe right calls Do Today', (tester) async {
        final fakeRepo = FakeBrainDumpRepository();
        final queue = [TriageItem.brainDump(brainDumpItem)];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentUserIdProvider.overrideWithValue('test'),
              brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
              triageQueueProvider.overrideWithValue(queue),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: const TriageFunnelScreen(),
            ),
          ),
        );

        await tester.fling(find.byType(Card), const Offset(600, 0), 1000);
        await tester.pumpAndSettle();

        expect(fakeRepo.updatedItem?.scheduledForDate, isNotNull);
      });
    });
  });
}
