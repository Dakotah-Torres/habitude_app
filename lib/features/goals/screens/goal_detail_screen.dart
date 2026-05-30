import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/goals_repository.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/projects_repository.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/goals/tasks_repository.dart';
import 'package:habitude/features/goals/screens/goal_form_screen.dart';
import 'package:habitude/features/goals/screens/project_detail_screen.dart';
import 'package:habitude/features/goals/screens/project_form_screen.dart';
import 'package:habitude/shared/theme.dart';

class GoalDetailScreen extends ConsumerStatefulWidget {
  final String goalId;

  const GoalDetailScreen({super.key, required this.goalId});

  @override
  ConsumerState<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends ConsumerState<GoalDetailScreen> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final goalAsync = ref.watch(goalStreamProvider(widget.goalId));
    final projectsAsync = ref.watch(
      projectsByGoalStreamProvider(widget.goalId),
    );

    return goalAsync.when(
      data: (goal) => Scaffold(
        appBar: AppBar(
          title: const Text('Goal'),
          actions: [
            if (!_isDeleting)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GoalFormScreen(initialGoal: goal),
                      ),
                    );
                  } else if (value == 'delete') {
                    _confirmDelete(context, ref, goal);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit goal')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete goal'),
                  ),
                ],
              ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GoalHeader(goal: goal),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'Projects',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.juniper,
                          ),
                        ),
                      ),
                      projectsAsync.when(
                        data: (projects) {
                          if (projects.isEmpty) {
                            return _EmptyProjectsView(goalId: widget.goalId);
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: projects.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final project = projects[index];
                              return _ProjectCard(project: project);
                            },
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Loading projects'),
                              ],
                            ),
                          ),
                        ),
                        error: (err, stack) => const _ErrorProjectsView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isDeleting)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Deleting goal and all nested items...'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: _isDeleting
            ? null
            : FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProjectFormScreen(goalId: widget.goalId),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Goal not found')),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Goal goal,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${goal.title}"?'),
        content: const Text(
          'This removes the goal and all its projects and tasks. This action is grounded but permanent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete goal'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      try {
        final goalsRepo = ref.read(goalsRepositoryProvider);
        final projectsRepo = ref.read(projectsRepositoryProvider);
        final tasksRepo = ref.read(tasksRepositoryProvider);

        // 1. Fetch current projects for this goal
        final projects = await projectsRepo.watchProjectsByGoal(goal.id).first;

        // 2. Cascade delete
        for (final project in projects) {
          // 2a. Fetch tasks for this project
          final tasks = await tasksRepo.watchTasksByParent(project.id).first;
          // Filter to only this project's tasks (as parentId can overlap if we were using non-unique IDs, but let's be safe)
          final projectTasks = tasks
              .where((t) => t.parentType == ParentType.project)
              .toList();

          for (final task in projectTasks) {
            await tasksRepo.deleteTask(task.id);
          }

          // 2b. Delete project
          await projectsRepo.deleteProject(project.id);
        }

        // 3. Delete the goal itself
        await goalsRepo.deleteGoal(goal.id);

        if (!context.mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!context.mounted) return;
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not delete goal. Please try again.'),
          ),
        );
      }
    }
  }
}

class _GoalHeader extends StatelessWidget {
  final Goal goal;

  const _GoalHeader({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.surfaceLight.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.juniper,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _GoalTypeChip(type: goal.type),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          project.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _ProjectStatusBadge(status: project.status),
              if (project.dueDate != null)
                Text(
                  'Due ${_formatDate(project.dueDate!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.juniper),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectDetailScreen(projectId: project.id),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class _ProjectStatusBadge extends StatelessWidget {
  final ProjectStatus status;

  const _ProjectStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = status.name[0].toUpperCase() + status.name.substring(1);
    Color color;
    switch (status) {
      case ProjectStatus.active:
        color = AppColors.ember;
        break;
      case ProjectStatus.completed:
        color = AppColors.saguaro;
        break;
      case ProjectStatus.archived:
        color = AppColors.mesaSky;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _EmptyProjectsView extends StatelessWidget {
  final String goalId;
  const _EmptyProjectsView({required this.goalId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 48,
              color: AppColors.juniper,
            ),
            const SizedBox(height: 16),
            const Text(
              'No projects yet.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Break this goal into a first clear project when you are ready.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectFormScreen(goalId: goalId),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add project'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorProjectsView extends StatelessWidget {
  const _ErrorProjectsView();

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
