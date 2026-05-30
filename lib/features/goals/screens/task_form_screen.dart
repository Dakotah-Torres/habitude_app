import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/goals/tasks_repository.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final String? parentId;
  final ParentType? parentType;
  final Task? initialTask;

  const TaskFormScreen({
    super.key,
    this.parentId,
    this.parentType,
    this.initialTask,
  }) : assert(initialTask != null || (parentId != null && parentType != null));

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _energyController;
  late TextEditingController _quotaController;
  late TaskType _type;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialTask?.title ?? '',
    );
    _energyController = TextEditingController(
      text: widget.initialTask?.energyScore.toString() ?? '0',
    );
    _quotaController = TextEditingController(
      text: widget.initialTask?.weeklyQuota?.toString() ?? '',
    );
    _type = widget.initialTask?.taskType ?? TaskType.oneTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _energyController.dispose();
    _quotaController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(tasksRepositoryProvider);
      final energyScore = int.parse(_energyController.text);
      final weeklyQuota = _type == TaskType.recurring
          ? int.tryParse(_quotaController.text)
          : null;

      if (widget.initialTask == null) {
        final newTask = Task(
          id: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          parentId: widget.parentId!,
          parentType: widget.parentType!,
          title: _titleController.text.trim(),
          energyScore: energyScore,
          taskType: _type,
          weeklyQuota: weeklyQuota,
          createdAt: DateTime.now().toUtc(),
        );
        await repository.addTask(newTask);
      } else {
        final updatedTask = widget.initialTask!.copyWith(
          title: _titleController.text.trim(),
          energyScore: energyScore,
          taskType: _type,
          weeklyQuota: weeklyQuota,
        );
        await repository.updateTask(updatedTask);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'Task was not saved. Nothing was lost; try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialTask != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit task' : 'New task')),
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
                      hintText: 'e.g., Water the plants',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Add a title to save this task.';
                      }
                      return null;
                    },
                    enabled: !_isSaving,
                    autofocus: !isEdit,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _energyController,
                    decoration: const InputDecoration(
                      labelText: 'Energy Score',
                      helperText: 'Higher means this asks for more effort.',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Energy must be zero or more.';
                      }
                      final score = int.tryParse(value);
                      if (score == null || score < 0) {
                        return 'Energy must be zero or more.';
                      }
                      return null;
                    },
                    enabled: !_isSaving,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Task Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<TaskType>(
                    segments: const [
                      ButtonSegment(
                        value: TaskType.oneTime,
                        label: Text('One-time'),
                      ),
                      ButtonSegment(
                        value: TaskType.recurring,
                        label: Text('Recurring'),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: _isSaving
                        ? null
                        : (newSelection) {
                            setState(() => _type = newSelection.first);
                          },
                  ),
                  if (_type == TaskType.recurring) ...[
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _quotaController,
                      decoration: const InputDecoration(
                        labelText: 'Weekly Target',
                        hintText: 'e.g., 3',
                        helperText: 'How many times per week?',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (_type == TaskType.recurring) {
                          if (value == null || value.isEmpty) {
                            return 'Add a weekly target for recurring tasks.';
                          }
                          final quota = int.tryParse(value);
                          if (quota == null || quota <= 0) {
                            return 'Target must be 1 or more.';
                          }
                        }
                        return null;
                      },
                      enabled: !_isSaving,
                    ),
                  ],
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
}
