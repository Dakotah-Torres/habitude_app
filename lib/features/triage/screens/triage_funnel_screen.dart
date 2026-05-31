import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';
import 'package:habitude/features/triage/brain_dump_repository.dart';
import 'package:habitude/features/triage/triage_service.dart';
import 'package:habitude/shared/theme.dart';
import 'package:habitude/shared/utils.dart';

class TriageFunnelScreen extends ConsumerStatefulWidget {
  const TriageFunnelScreen({super.key});

  @override
  ConsumerState<TriageFunnelScreen> createState() => _TriageFunnelScreenState();
}

class _TriageFunnelScreenState extends ConsumerState<TriageFunnelScreen> {
  int _currentIndex = 0;

  void _next() {
    setState(() {
      _currentIndex++;
    });
  }

  void _doToday(TriageItem item) {
    item.when(
      brainDump: (brainDump) {
        final today = DateTime.now().toUtc();
        final updated = brainDump.copyWith(
          scheduledForDate: DateTime.utc(today.year, today.month, today.day),
        );
        ref.read(brainDumpRepositoryProvider).updateItem(updated);
      },
      task: (task, _) {
        final completion = TaskCompletion(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          taskId: task.id,
          energyScore: task.energyScore,
          completedAt: DateTime.now().toUtc(),
        );
        ref.read(taskCompletionRepositoryProvider).addCompletion(completion);
      },
    );
    _next();
  }

  void _tomorrow(TriageItem item) {
    item.when(
      brainDump: (brainDump) {
        final tomorrow = DateTime.now().toUtc().add(const Duration(days: 1));
        final updated = brainDump.copyWith(
          backloggedUntil: DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day),
        );
        ref.read(brainDumpRepositoryProvider).updateItem(updated);
      },
      task: (_, __) {
        // No-op for tasks
      },
    );
    _next();
  }

  void _remove(TriageItem item) {
    item.when(
      brainDump: (brainDump) {
        ref.read(brainDumpRepositoryProvider).deleteItem(brainDump.id);
      },
      task: (_, __) {
        // No-op for tasks
      },
    );
    _next();
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(triageQueueProvider);

    if (_currentIndex >= queue.length) {
      return const _CompletionState();
    }

    final currentItem = queue[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Triage'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Card ${_currentIndex + 1} of ${queue.length}',
                  style: const TextStyle(color: AppColors.mesaSky),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _TriageCard(
                    item: currentItem,
                    onDoToday: () => _doToday(currentItem),
                    onTomorrow: () => _tomorrow(currentItem),
                    onRemove: () => _remove(currentItem),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _TriageButton(
                      key: const Key('triage_tomorrow'),
                      label: 'Tomorrow',
                      icon: Icons.calendar_today_outlined,
                      color: AppColors.mesaSky,
                      onPressed: () => _tomorrow(currentItem),
                    ),
                    _TriageButton(
                      key: const Key('triage_remove'),
                      label: 'Remove',
                      icon: Icons.delete_outline,
                      color: AppColors.juniper,
                      onPressed: () => _remove(currentItem),
                    ),
                    _TriageButton(
                      key: const Key('triage_do_today'),
                      label: 'Do Today',
                      icon: Icons.bolt,
                      color: AppColors.ember,
                      onPressed: () => _doToday(currentItem),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TriageCard extends StatelessWidget {
  final TriageItem item;
  final VoidCallback onDoToday;
  final VoidCallback onTomorrow;
  final VoidCallback onRemove;

  const _TriageCard({
    required this.item,
    required this.onDoToday,
    required this.onTomorrow,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 500) {
          onDoToday();
        } else if (details.primaryVelocity! < -500) {
          onTomorrow();
        }
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 500) {
          onRemove();
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: item.when(
            brainDump: (brainDump) => _BrainDumpContent(item: brainDump),
            task: (task, completions) => _TaskContent(task: task, completions: completions),
          ),
        ),
      ),
    );
  }
}

class _BrainDumpContent extends StatelessWidget {
  final BrainDumpItem item;
  const _BrainDumpContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _EyebrowChip(label: 'Brain dump'),
        const SizedBox(height: 24),
        Expanded(
          child: Text(
            item.text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.juniper,
                ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          formatRelativeTime(item.createdAt),
          style: const TextStyle(color: AppColors.mesaSky),
        ),
        const SizedBox(height: 8),
        const Text(
          'Decide where this thought belongs for now.',
          style: TextStyle(fontSize: 12, color: AppColors.mesaSky),
        ),
      ],
    );
  }
}

class _TaskContent extends StatelessWidget {
  final Task task;
  final int completions;
  const _TaskContent({required this.task, required this.completions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _EyebrowChip(label: 'Recurring task'),
        const SizedBox(height: 24),
        Expanded(
          child: Text(
            task.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.juniper,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.bolt, size: 16, color: AppColors.ember),
            const SizedBox(width: 4),
            Text('${task.energyScore} energy'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          completions == 0 
            ? 'Not started this week'
            : '$completions of ${task.weeklyQuota} this week',
          style: const TextStyle(color: AppColors.mesaSky),
        ),
        const SizedBox(height: 16),
        const Text(
          'A small check-in keeps the rhythm alive.',
          style: TextStyle(fontSize: 12, color: AppColors.mesaSky),
        ),
      ],
    );
  }
}

class _EyebrowChip extends StatelessWidget {
  final String label;
  const _EyebrowChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.juniper,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _TriageButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _TriageButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: color.withOpacity(0.1),
            foregroundColor: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _CompletionState extends StatelessWidget {
  const _CompletionState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 64, color: AppColors.saguaro),
              const SizedBox(height: 24),
              Text(
                'All caught up!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.juniper,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your head is clearer. You can come back if more shows up.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mesaSky),
              ),
              const SizedBox(height: 48),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.juniper,
                ),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
