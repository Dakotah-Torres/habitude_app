import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/firestore_paths.dart';

part 'task_completion_repository.g.dart';

class TaskCompletionRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  TaskCompletionRepository(this._firestore, {required String uid}) : _uid = uid;

  Stream<List<TaskCompletion>> watchCompletions() {
    return _firestore
        .collection(FirestorePaths.taskCompletions(_uid))
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskCompletion.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<TaskCompletion>> watchCompletionsSince(DateTime since) {
    return _firestore
        .collection(FirestorePaths.taskCompletions(_uid))
        .where('completedAt', isGreaterThanOrEqualTo: since.toIso8601String())
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskCompletion.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> addCompletion(TaskCompletion c) {
    return _firestore
        .collection(FirestorePaths.taskCompletions(_uid))
        .doc(c.id)
        .set(c.toJson());
  }

  Future<void> deleteCompletion(String id) {
    return _firestore
        .collection(FirestorePaths.taskCompletions(_uid))
        .doc(id)
        .delete();
  }
}

@riverpod
TaskCompletionRepository taskCompletionRepository(Ref ref) {
  final uid = ref.watch(currentUserIdProvider);
  return TaskCompletionRepository(FirebaseFirestore.instance, uid: uid);
}

@riverpod
Stream<List<TaskCompletion>> taskCompletionsStream(Ref ref) {
  final repository = ref.watch(taskCompletionRepositoryProvider);
  return repository.watchCompletions();
}
