import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/features/timer/tracker.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/firestore_paths.dart';

part 'tracker_repository.g.dart';

class TrackerRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  TrackerRepository(this._firestore, {required String uid}) : _uid = uid;

  Stream<List<Tracker>> watchTrackers() {
    return _firestore
        .collection(FirestorePaths.trackers(_uid))
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Tracker.fromJson(doc.data())).toList(),
        );
  }

  Stream<List<Tracker>> watchTrackersByTask(String taskId) {
    return _firestore
        .collection(FirestorePaths.trackers(_uid))
        .where('taskId', isEqualTo: taskId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Tracker.fromJson(doc.data())).toList(),
        );
  }

  Future<void> addTracker(Tracker t) {
    return _firestore
        .collection(FirestorePaths.trackers(_uid))
        .doc(t.id)
        .set(t.toJson());
  }

  Future<void> updateTracker(Tracker t) {
    return _firestore
        .collection(FirestorePaths.trackers(_uid))
        .doc(t.id)
        .set(t.toJson());
  }
}

@riverpod
TrackerRepository trackerRepository(Ref ref) {
  final uid = ref.watch(currentUserIdProvider);
  return TrackerRepository(FirebaseFirestore.instance, uid: uid);
}

@riverpod
Stream<List<Tracker>> trackersStream(Ref ref) {
  final repository = ref.watch(trackerRepositoryProvider);
  return repository.watchTrackers();
}
