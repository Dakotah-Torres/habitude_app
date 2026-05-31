import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';
import 'package:habitude/features/triage/brain_dump_repository.dart';

void main() {
  group('BrainDumpRepository', () {
    late FakeFirebaseFirestore firestore;
    late BrainDumpRepository repository;
    const uid = 'user123';

    setUp(() {
      firestore = FakeFirebaseFirestore();
      repository = BrainDumpRepository(firestore, uid: uid);
    });

    test('watchActiveItems emits empty list when collection is empty', () async {
      final items = await repository.watchActiveItems(DateTime.now()).first;
      expect(items, isEmpty);
    });

    test('watchActiveItems includes items backlogged until yesterday', () async {
      final now = DateTime.now().toUtc();
      final yesterday = now.subtract(const Duration(days: 1));
      final item = BrainDumpItem(
        id: '1',
        text: 'Backlogged until yesterday',
        createdAt: now.subtract(const Duration(hours: 1)),
        backloggedUntil: DateTime.utc(yesterday.year, yesterday.month, yesterday.day),
      );

      await repository.addItem(item);

      final activeItems = await repository.watchActiveItems(now).first;
      expect(activeItems, hasLength(1));
      expect(activeItems.first.id, '1');
    });

    test('watchActiveItems excludes items backlogged until tomorrow', () async {
      final now = DateTime.now().toUtc();
      final tomorrow = now.add(const Duration(days: 1));
      final item = BrainDumpItem(
        id: '2',
        text: 'Backlogged until tomorrow',
        createdAt: now.subtract(const Duration(hours: 1)),
        backloggedUntil: DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day),
      );

      await repository.addItem(item);

      final activeItems = await repository.watchActiveItems(now).first;
      expect(activeItems, isEmpty);
    });

    test('watchActiveItems excludes items scheduled for today', () async {
      final now = DateTime.now().toUtc();
      final item = BrainDumpItem(
        id: '3',
        text: 'Scheduled for today',
        createdAt: now.subtract(const Duration(hours: 1)),
        scheduledForDate: DateTime.utc(now.year, now.month, now.day),
      );

      await repository.addItem(item);

      final activeItems = await repository.watchActiveItems(now).first;
      expect(activeItems, isEmpty);
    });

    test('deleteItem removes item from all items stream', () async {
      final now = DateTime.now().toUtc();
      final item = BrainDumpItem(
        id: '4',
        text: 'To be deleted',
        createdAt: now,
      );

      await repository.addItem(item);
      expect(await repository.watchAllItems().first, hasLength(1));

      await repository.deleteItem('4');
      expect(await repository.watchAllItems().first, isEmpty);
    });

    test('watchAllItems returns items in createdAt descending order', () async {
      final now = DateTime.now().toUtc();
      final item1 = BrainDumpItem(id: '1', text: 'Old', createdAt: now.subtract(const Duration(hours: 1)));
      final item2 = BrainDumpItem(id: '2', text: 'New', createdAt: now);

      await repository.addItem(item1);
      await repository.addItem(item2);

      final items = await repository.watchAllItems().first;
      expect(items, hasLength(2));
      expect(items.first.id, '2');
      expect(items.last.id, '1');
    });
  });
}
