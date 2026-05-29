import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/firestore_paths.dart';

part 'tasks_repository.g.dart';

class TasksRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  TasksRepository(this._firestore, {required String uid}) : _uid = uid;

  Stream<List<Task>> watchTasks() {
    return _firestore
        .collection(FirestorePaths.tasks(_uid))
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList(),
        );
  }

  Stream<List<Task>> watchTasksByParent(String parentId) {
    return _firestore
        .collection(FirestorePaths.tasks(_uid))
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList(),
        );
  }

  Future<void> addTask(Task task) {
    return _firestore
        .collection(FirestorePaths.tasks(_uid))
        .doc(task.id)
        .set(task.toJson());
  }

  Future<void> updateTask(Task task) {
    return _firestore
        .collection(FirestorePaths.tasks(_uid))
        .doc(task.id)
        .set(task.toJson());
  }

  Future<void> deleteTask(String id) {
    return _firestore.collection(FirestorePaths.tasks(_uid)).doc(id).delete();
  }
}

@riverpod
TasksRepository tasksRepository(Ref ref) {
  final uid = ref.watch(currentUserIdProvider);
  return TasksRepository(FirebaseFirestore.instance, uid: uid);
}

@riverpod
Stream<List<Task>> tasksStream(Ref ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.watchTasks();
}
