import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/goals_repository.dart';

class GoalFormScreen extends ConsumerStatefulWidget {
  final Goal? initialGoal;

  const GoalFormScreen({super.key, this.initialGoal});

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late GoalType _type;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialGoal?.title ?? '',
    );
    _type = widget.initialGoal?.type ?? GoalType.continuous;
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
      final repository = ref.read(goalsRepositoryProvider);
      if (widget.initialGoal == null) {
        final newGoal = Goal(
          id: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          type: _type,
          createdAt: DateTime.now().toUtc(),
        );
        await repository.addGoal(newGoal);
      } else {
        final updatedGoal = widget.initialGoal!.copyWith(
          title: _titleController.text.trim(),
          type: _type,
        );
        await repository.updateGoal(updatedGoal);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'Goal was not saved. Nothing was lost; try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialGoal != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit goal' : 'New goal')),
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
                      hintText: 'e.g., Learn Flutter',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Add a title to save this goal.';
                      }
                      return null;
                    },
                    enabled: !_isSaving,
                    autofocus: !isEdit,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Goal Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<GoalType>(
                    segments: const [
                      ButtonSegment(
                        value: GoalType.continuous,
                        label: Text('Continuous'),
                        icon: Icon(Icons.loop),
                      ),
                      ButtonSegment(
                        value: GoalType.finite,
                        label: Text('Finite'),
                        icon: Icon(Icons.flag),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: _isSaving
                        ? null
                        : (newSelection) {
                            setState(() => _type = newSelection.first);
                          },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _type == GoalType.continuous
                        ? 'Continuous supports ongoing effort'
                        : 'Finite has a finish line',
                    style: Theme.of(context).textTheme.bodySmall,
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
}
