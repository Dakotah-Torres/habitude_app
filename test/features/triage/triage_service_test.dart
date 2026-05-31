import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';
import 'package:habitude/features/triage/triage_service.dart';

void main() {
  final service = TriageService();

  group('TriageService', () {
    group('todaysBrainDumpItems', () {
      final now = DateTime.now().toUtc();
      final today = DateTime.utc(now.year, now.month, now.day);

      test('includes items with null backlog and null scheduled', () {
        final item = BrainDumpItem(id: '1', text: 'T1', createdAt: now);
        expect(service.todaysBrainDumpItems([item], today), contains(item));
      });

      test('excludes scheduled items', () {
        final item = BrainDumpItem(id: '2', text: 'T2', createdAt: now, scheduledForDate: today);
        expect(service.todaysBrainDumpItems([item], today), isEmpty);
      });

      test('excludes items backlogged until tomorrow', () {
        final tomorrow = today.add(const Duration(days: 1));
        final item = BrainDumpItem(id: '3', text: 'T3', createdAt: now, backloggedUntil: tomorrow);
        expect(service.todaysBrainDumpItems([item], today), isEmpty);
      });

      test('includes items backlogged until yesterday', () {
        final yesterday = today.subtract(const Duration(days: 1));
        final item = BrainDumpItem(id: '4', text: 'T4', createdAt: now, backloggedUntil: yesterday);
        expect(service.todaysBrainDumpItems([item], today), contains(item));
      });
    });

    group('completionsThisWeek', () {
      // 2026-06-01 is a Monday
      final monday = DateTime.utc(2026, 6, 1);
      final sunday = DateTime.utc(2026, 6, 7, 23, 59, 59);
      final prevSunday = DateTime.utc(2026, 5, 31, 23, 59, 59);

      test('counts completions on Monday and Sunday of same week', () {
        final completions = [
          TaskCompletion(id: '1', taskId: 't1', energyScore: 1, completedAt: monday),
          TaskCompletion(id: '2', taskId: 't1', energyScore: 1, completedAt: sunday),
          TaskCompletion(id: '3', taskId: 't1', energyScore: 1, completedAt: prevSunday),
        ];

        expect(service.completionsThisWeek('t1', completions, monday), 2);
        expect(service.completionsThisWeek('t1', completions, sunday), 2);
      });

      test('today=Monday: previous Sunday is not in same week', () {
        final completions = [
          TaskCompletion(id: '3', taskId: 't1', energyScore: 1, completedAt: prevSunday),
        ];
        expect(service.completionsThisWeek('t1', completions, monday), 0);
      });
    });

    group('pendingRecurringTasks', () {
      final today = DateTime.utc(2026, 6, 1); // Monday
      final recurringTask = Task(
        id: 'rt1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Recurring',
        energyScore: 1,
        taskType: TaskType.recurring,
        weeklyQuota: 3,
        createdAt: today,
      );
      final oneTimeTask = Task(
        id: 'ot1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'One-time',
        energyScore: 1,
        taskType: TaskType.oneTime,
        createdAt: today,
      );

      test('includes recurring task with quota not met', () {
        final completions = [
          TaskCompletion(id: '1', taskId: 'rt1', energyScore: 1, completedAt: today),
        ];
        expect(service.pendingRecurringTasks([recurringTask], completions, today), contains(recurringTask));
      });

      test('excludes recurring task with quota met', () {
        final completions = [
          TaskCompletion(id: '1', taskId: 'rt1', energyScore: 1, completedAt: today),
          TaskCompletion(id: '2', taskId: 'rt1', energyScore: 1, completedAt: today.add(const Duration(days: 1))),
          TaskCompletion(id: '3', taskId: 'rt1', energyScore: 1, completedAt: today.add(const Duration(days: 2))),
        ];
        expect(service.pendingRecurringTasks([recurringTask], completions, today), isEmpty);
      });

      test('excludes one-time tasks', () {
        expect(service.pendingRecurringTasks([oneTimeTask], [], today), isEmpty);
      });
    });
  });
}
