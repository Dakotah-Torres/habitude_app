import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/projects_repository.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/goals/tasks_repository.dart';
import 'package:habitude/features/goals/screens/project_form_screen.dart';
import 'package:habitude/features/goals/screens/task_form_screen.dart';
import 'package:habitude/shared/theme.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final projectAsync = ref.watch(projectStreamProvider(widget.projectId));
    final tasksAsync = ref.watch(tasksByParentStreamProvider(widget.projectId));

    return projectAsync.when(
      data: (project) => Scaffold(
        appBar: AppBar(
          title: const Text('Project'),
          actions: [
            if (!_isDeleting)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProjectFormScreen(initialProject: project),
                      ),
                    );
                  } else if (value == 'delete') {
                    _confirmDeleteProject(context, ref, project);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit project'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete project'),
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
                      _ProjectHeader(project: project),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.juniper,
                          ),
                        ),
                      ),
                      tasksAsync.when(
                        data: (tasks) {
                          final projectTasks = tasks
                              .where(
                                (task) => task.parentType == ParentType.project,
                              )
                              .toList();
                          if (projectTasks.isEmpty) {
                            return _EmptyTasksView(projectId: widget.projectId);
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: projectTasks.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final task = projectTasks[index];
                              return _TaskCard(task: task);
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
                                Text('Loading tasks'),
                              ],
                            ),
                          ),
                        ),
                        error: (err, stack) => const _ErrorTasksView(),
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
                          Text('Deleting project and tasks...'),
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
                    builder: (_) => TaskFormScreen(
                      parentId: widget.projectId,
                      parentType: ParentType.project,
                    ),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Project not found')),
      ),
    );
  }

  Future<void> _confirmDeleteProject(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${project.title}"?'),
        content: const Text(
          'This removes the project and all its tasks. This action is grounded but permanent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete project'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      try {
        final tasksRepo = ref.read(tasksRepositoryProvider);
        final projectsRepo = ref.read(projectsRepositoryProvider);

        // 1. Fetch current tasks for this project
        final tasks = await tasksRepo.watchTasksByParent(project.id).first;
        final projectTasks = tasks
            .where((t) => t.parentType == ParentType.project)
            .toList();

        // 2. Cascade delete tasks
        for (final task in projectTasks) {
          await tasksRepo.deleteTask(task.id);
        }

        // 3. Delete the project
        await projectsRepo.deleteProject(project.id);

        if (!context.mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!context.mounted) return;
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not delete project. Please try again.'),
          ),
        );
      }
    }
  }
}

class _ProjectHeader extends StatelessWidget {
  final Project project;

  const _ProjectHeader({required this.project});

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
            project.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.juniper,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
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
        ],
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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

class _TaskCard extends ConsumerWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(task.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _EnergyIndicator(score: task.energyScore),
              _TaskTypeChip(type: task.taskType),
              if (task.taskType == TaskType.recurring &&
                  task.weeklyQuota != null)
                Text(
                  '${task.weeklyQuota}/week target',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(initialTask: task),
                ),
              );
            } else if (value == 'delete') {
              _confirmDeleteTask(context, ref, task);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit task')),
            const PopupMenuItem(value: 'delete', child: Text('Delete task')),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${task.title}"?'),
        content: const Text(
          'This removes the task. This action is grounded but permanent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete task'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(tasksRepositoryProvider).deleteTask(task.id);
    }
  }
}

class _EnergyIndicator extends StatelessWidget {
  final int score;

  const _EnergyIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.bolt, size: 14, color: AppColors.ember),
        const SizedBox(width: 2),
        Text(
          '$score energy',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _TaskTypeChip extends StatelessWidget {
  final TaskType type;

  const _TaskTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final label = type == TaskType.oneTime ? 'One-time' : 'Recurring';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.mesaSky.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.mesaSky.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.mesaSky,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _EmptyTasksView extends StatelessWidget {
  final String projectId;
  const _EmptyTasksView({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(Icons.task_alt, size: 48, color: AppColors.juniper),
            const SizedBox(height: 16),
            const Text(
              'No tasks yet.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add one next action. Small counts.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(
                    parentId: projectId,
                    parentType: ParentType.project,
                  ),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add task'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorTasksView extends StatelessWidget {
  const _ErrorTasksView();

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
