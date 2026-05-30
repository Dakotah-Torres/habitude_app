import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/projects_repository.dart';
import 'package:habitude/shared/theme.dart';

class ProjectFormScreen extends ConsumerStatefulWidget {
  final String? goalId;
  final Project? initialProject;

  const ProjectFormScreen({super.key, this.goalId, this.initialProject})
    : assert(goalId != null || initialProject != null);

  @override
  ConsumerState<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends ConsumerState<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late ProjectStatus _status;
  DateTime? _dueDate;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialProject?.title ?? '',
    );
    _status = widget.initialProject?.status ?? ProjectStatus.active;
    _dueDate = widget.initialProject?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(projectsRepositoryProvider);
      if (widget.initialProject == null) {
        final newProject = Project(
          id: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          goalId: widget.goalId!,
          title: _titleController.text.trim(),
          status: _status,
          dueDate: _dueDate,
          createdAt: DateTime.now().toUtc(),
        );
        await repository.addProject(newProject);
      } else {
        final updatedProject = widget.initialProject!.copyWith(
          title: _titleController.text.trim(),
          status: _status,
          dueDate: _dueDate,
        );
        await repository.updateProject(updatedProject);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'Project was not saved. Nothing was lost; try again.';
        });
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialProject != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit project' : 'New project')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g., Build the UI',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Add a title to save this project.';
                      }
                      return null;
                    },
                    enabled: !_isSaving,
                    autofocus: !isEdit,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<ProjectStatus>(
                    segments: const [
                      ButtonSegment(
                        value: ProjectStatus.active,
                        label: Text('Active'),
                      ),
                      ButtonSegment(
                        value: ProjectStatus.completed,
                        label: Text('Completed'),
                      ),
                      ButtonSegment(
                        value: ProjectStatus.archived,
                        label: Text('Archived'),
                      ),
                    ],
                    selected: {_status},
                    onSelectionChanged: _isSaving
                        ? null
                        : (newSelection) {
                            setState(() => _status = newSelection.first);
                          },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Due Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dueDate == null
                              ? 'No due date'
                              : _formatDate(_dueDate!),
                          style: TextStyle(
                            color: _dueDate == null
                                ? Colors.grey
                                : AppColors.juniper,
                          ),
                        ),
                      ),
                      if (_dueDate != null)
                        IconButton(
                          onPressed: _isSaving
                              ? null
                              : () => setState(() => _dueDate = null),
                          icon: const Icon(Icons.clear),
                        ),
                      TextButton(
                        onPressed: _isSaving ? null : _pickDate,
                        child: Text(_dueDate == null ? 'Set date' : 'Change'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  if (_errorMessage != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
