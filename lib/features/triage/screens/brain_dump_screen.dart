import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';
import 'package:habitude/features/triage/brain_dump_repository.dart';
import 'package:habitude/features/triage/screens/triage_funnel_screen.dart';
import 'package:habitude/features/triage/triage_service.dart';
import 'package:habitude/shared/theme.dart';
import 'package:habitude/shared/utils.dart';

class BrainDumpScreen extends ConsumerStatefulWidget {
  const BrainDumpScreen({super.key});

  @override
  ConsumerState<BrainDumpScreen> createState() => _BrainDumpScreenState();
}

class _BrainDumpScreenState extends ConsumerState<BrainDumpScreen> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final item = BrainDumpItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now().toUtc(),
    );

    ref.read(brainDumpRepositoryProvider).addItem(item);
    _textController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(brainDumpStreamProvider);
    final triageCount = ref.watch(triagePendingCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brain Dump'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Drop the thought here.',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        onSubmitted: (_) => _addItem(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: itemsAsync.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return const _EmptyState();
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _BrainDumpListTile(item: item);
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading brain dump'),
                      ],
                    ),
                  ),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Brain dump did not load',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your capture space is still here. Try again in a moment.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.refresh(brainDumpStreamProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: triageCount > 0
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TriageFunnelScreen(),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.bolt),
                    label: Text(
                      triageCount > 0
                          ? 'Start triage'
                          : 'Nothing waiting right now.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: AppColors.mesaSky),
            SizedBox(height: 16),
            Text(
              'Nothing rattling around.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.juniper,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'When a thought shows up, drop it here and keep moving.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mesaSky),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrainDumpListTile extends ConsumerWidget {
  final BrainDumpItem item;

  const _BrainDumpListTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        item.text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        formatRelativeTime(item.createdAt),
        style: const TextStyle(fontSize: 12, color: AppColors.mesaSky),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => _deleteItem(context, ref),
      ),
    );
  }

  void _deleteItem(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove this thought?'),
        content: const Text(
          'This clears it from the dump. No shame if it was just noise.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(brainDumpRepositoryProvider).deleteItem(item.id);
    }
  }
}
