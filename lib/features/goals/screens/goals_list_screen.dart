import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/goals_repository.dart';
import 'package:habitude/features/goals/screens/goal_detail_screen.dart';
import 'package:habitude/features/goals/screens/goal_form_screen.dart';
import 'package:habitude/shared/theme.dart';

class GoalsListScreen extends ConsumerWidget {
  const GoalsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Habitude')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: goalsAsync.when(
            data: (goals) {
              if (goals.isEmpty) {
                return const _EmptyGoalsView();
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: goals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return _GoalCard(goal: goal);
                },
              );
            },
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading goals'),
                ],
              ),
            ),
            error: (error, stack) => const _ErrorGoalsView(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GoalFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Goal goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(goal.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _GoalTypeChip(type: goal.type),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.juniper),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GoalDetailScreen(goalId: goal.id)),
        ),
      ),
    );
  }
}

class _GoalTypeChip extends StatelessWidget {
  final GoalType type;

  const _GoalTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final label = type == GoalType.continuous ? 'Continuous' : 'Finite';
    final color = type == GoalType.continuous
        ? AppColors.saguaro
        : AppColors.mesaSky;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _EmptyGoalsView extends StatelessWidget {
  const _EmptyGoalsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flag_outlined, size: 64, color: AppColors.juniper),
            const SizedBox(height: 24),
            Text(
              'Start with one goal.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.juniper,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Name the direction you want your effort to point.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GoalFormScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add goal'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorGoalsView extends StatelessWidget {
  const _ErrorGoalsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.juniper),
            SizedBox(height: 16),
            Text(
              'Something did not load',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your goals are still safe. Try again in a moment.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
