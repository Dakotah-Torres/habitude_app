import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/firestore_paths.dart';

part 'brain_dump_repository.g.dart';

class BrainDumpRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  BrainDumpRepository(this._firestore, {required String uid}) : _uid = uid;

  Stream<List<BrainDumpItem>> watchAllItems() {
    return _firestore
        .collection(FirestorePaths.brainDumpItems(_uid))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BrainDumpItem.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<BrainDumpItem>> watchActiveItems(DateTime today) {
    // Normalizing today to start of day UTC
    final todayDate = DateTime.utc(today.year, today.month, today.day);

    return watchAllItems().map((items) {
      return items.where((item) {
        if (item.scheduledForDate != null) return false;
        if (item.backloggedUntil == null) return true;
        
        final backlogDate = DateTime.utc(
          item.backloggedUntil!.year,
          item.backloggedUntil!.month,
          item.backloggedUntil!.day,
        );
        return !backlogDate.isAfter(todayDate);
      }).toList();
    });
  }

  Future<void> addItem(BrainDumpItem item) {
    return _firestore
        .collection(FirestorePaths.brainDumpItems(_uid))
        .doc(item.id)
        .set(item.toJson());
  }

  Future<void> updateItem(BrainDumpItem item) {
    return _firestore
        .collection(FirestorePaths.brainDumpItems(_uid))
        .doc(item.id)
        .set(item.toJson());
  }

  Future<void> deleteItem(String id) {
    return _firestore
        .collection(FirestorePaths.brainDumpItems(_uid))
        .doc(id)
        .delete();
  }
}

@riverpod
BrainDumpRepository brainDumpRepository(Ref ref) {
  final uid = ref.watch(currentUserIdProvider);
  return BrainDumpRepository(FirebaseFirestore.instance, uid: uid);
}

@riverpod
Stream<List<BrainDumpItem>> brainDumpStream(Ref ref) {
  final repository = ref.watch(brainDumpRepositoryProvider);
  return repository.watchAllItems();
}

@riverpod
Stream<List<BrainDumpItem>> brainDumpActiveItems(Ref ref) {
  final repository = ref.watch(brainDumpRepositoryProvider);
  return repository.watchActiveItems(DateTime.now().toUtc());
}
