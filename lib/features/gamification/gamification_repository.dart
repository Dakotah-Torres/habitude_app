import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'rank_up_event.dart';
import '../../shared/auth_repository.dart';
import '../../shared/firestore_paths.dart';

part 'gamification_repository.g.dart';

class GamificationRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  GamificationRepository(this._firestore, {required String uid}) : _uid = uid;

  Stream<List<RankUpEvent>> watchAllRankUpEvents() {
    return _firestore
        .collection(FirestorePaths.rankUpEvents(_uid))
        .orderBy('triggeredAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RankUpEvent.fromJson(doc.data()))
            .toList());
  }

  Future<void> addRankUpEvent(RankUpEvent event) {
    return _firestore
        .collection(FirestorePaths.rankUpEvents(_uid))
        .doc(event.id)
        .set(event.toJson());
  }

  Stream<Set<String>> watchUnlockedTaskIds() {
    return watchAllRankUpEvents()
        .map((events) => events.map((e) => e.taskId).toSet());
  }
}

@riverpod
GamificationRepository gamificationRepository(Ref ref) {
  final uid = ref.watch(currentUserIdProvider);
  return GamificationRepository(FirebaseFirestore.instance, uid: uid);
}

@riverpod
Stream<List<RankUpEvent>> rankUpEvents(Ref ref) {
  return ref.watch(gamificationRepositoryProvider).watchAllRankUpEvents();
}

@riverpod
Stream<Set<String>> unlockedTaskIds(Ref ref) {
  return ref.watch(gamificationRepositoryProvider).watchUnlockedTaskIds();
}
