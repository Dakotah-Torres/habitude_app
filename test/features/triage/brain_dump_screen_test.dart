import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';
import 'package:habitude/features/triage/brain_dump_repository.dart';
import 'package:habitude/features/triage/screens/brain_dump_screen.dart';
import 'package:habitude/features/triage/triage_service.dart';
import 'package:habitude/shared/theme.dart';

class FakeBrainDumpRepository extends BrainDumpRepository {
  FakeBrainDumpRepository() : super(FakeFirebaseFirestore(), uid: 'test');
  
  final List<BrainDumpItem> _items = [];
  bool addItemCalled = false;
  bool deleteItemCalled = false;

  @override
  Stream<List<BrainDumpItem>> watchAllItems() => Stream.value(List.from(_items));

  @override
  Stream<List<BrainDumpItem>> watchActiveItems(DateTime today) => Stream.value(List.from(_items));

  @override
  Future<void> addItem(BrainDumpItem item) async {
    addItemCalled = true;
    _items.add(item);
  }

  @override
  Future<void> deleteItem(String id) async {
    deleteItemCalled = true;
    _items.removeWhere((i) => i.id == id);
  }
}

void main() {
  group('BrainDumpScreen', () {
    testWidgets('shows empty state when inbox is empty', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            brainDumpStreamProvider.overrideWith((ref) => fakeRepo.watchAllItems()),
            triagePendingCountProvider.overrideWithValue(0),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const BrainDumpScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Nothing rattling around.'), findsOneWidget);
      expect(find.text('Nothing waiting right now.'), findsOneWidget);
    });

    testWidgets('shows items in the list', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();
      await fakeRepo.addItem(BrainDumpItem(
        id: '1',
        text: 'Test Thought',
        createdAt: DateTime.now().toUtc(),
      ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            brainDumpStreamProvider.overrideWith((ref) => fakeRepo.watchAllItems()),
            triagePendingCountProvider.overrideWithValue(1),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const BrainDumpScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Thought'), findsOneWidget);
      expect(find.text('Start triage'), findsOneWidget);
    });

    testWidgets('adds item and clears text field', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            brainDumpStreamProvider.overrideWith((ref) => fakeRepo.watchAllItems()),
            triagePendingCountProvider.overrideWithValue(0),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const BrainDumpScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New Thought');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(fakeRepo.addItemCalled, isTrue);
      // Verify text field is cleared
      expect(find.text('New Thought'), findsNothing);
    });

    testWidgets('deletes item after confirmation', (tester) async {
      final fakeRepo = FakeBrainDumpRepository();
      await fakeRepo.addItem(BrainDumpItem(
        id: '1',
        text: 'Thought to delete',
        createdAt: DateTime.now().toUtc(),
      ));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            brainDumpRepositoryProvider.overrideWithValue(fakeRepo),
            brainDumpStreamProvider.overrideWith((ref) => fakeRepo.watchAllItems()),
            triagePendingCountProvider.overrideWithValue(1),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const BrainDumpScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Remove this thought?'), findsOneWidget);
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(fakeRepo.deleteItemCalled, isTrue);
    });
  });
}
