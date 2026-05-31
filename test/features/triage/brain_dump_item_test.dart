import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';
import 'package:habitude/shared/firestore_paths.dart';

void main() {
  group('BrainDumpItem', () {
    test('JSON roundtrip preserves all fields including null optionals', () {
      final now = DateTime.now().toUtc();
      final item = BrainDumpItem(
        id: '123',
        text: 'Test thought',
        createdAt: now,
      );

      final json = item.toJson();
      final fromJson = BrainDumpItem.fromJson(json);

      expect(fromJson.id, item.id);
      expect(fromJson.text, item.text);
      expect(fromJson.createdAt, item.createdAt);
      expect(fromJson.backloggedUntil, isNull);
      expect(fromJson.scheduledForDate, isNull);
    });

    test('JSON roundtrip preserves set optional fields', () {
      final now = DateTime.now().toUtc();
      final today = DateTime(now.year, now.month, now.day).toUtc();
      final item = BrainDumpItem(
        id: '123',
        text: 'Test thought',
        createdAt: now,
        backloggedUntil: today,
        scheduledForDate: today,
      );

      final json = item.toJson();
      final fromJson = BrainDumpItem.fromJson(json);

      expect(fromJson.backloggedUntil, today);
      expect(fromJson.scheduledForDate, today);
    });
  });

  group('FirestorePaths', () {
    test('brainDumpItems path is correct', () {
      expect(
        FirestorePaths.brainDumpItems('abc123'),
        'users/abc123/brain_dump_items',
      );
    });
  });
}
