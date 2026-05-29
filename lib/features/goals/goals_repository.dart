import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/firestore_paths.dart';

part 'goals_repository.g.dart';

class GoalsRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  GoalsRepository(this._firestore, {required String uid}) : _uid = uid;

  Stream<List<Goal>> watchGoals() {
    return _firestore
        .collection(FirestorePaths.goals(_uid))
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList(),
        );
  }

  Future<void> addGoal(Goal goal) {
    return _firestore
        .collection(FirestorePaths.goals(_uid))
        .doc(goal.id)
        .set(goal.toJson());
  }

  Future<void> updateGoal(Goal goal) {
    return _firestore
        .collection(FirestorePaths.goals(_uid))
        .doc(goal.id)
        .set(goal.toJson());
  }

  Future<void> deleteGoal(String id) {
    return _firestore.collection(FirestorePaths.goals(_uid)).doc(id).delete();
  }
}

@riverpod
GoalsRepository goalsRepository(Ref ref) {
  final uid = ref.watch(currentUserIdProvider);
  return GoalsRepository(FirebaseFirestore.instance, uid: uid);
}

@riverpod
Stream<List<Goal>> goalsStream(Ref ref) {
  final repository = ref.watch(goalsRepositoryProvider);
  return repository.watchGoals();
}
