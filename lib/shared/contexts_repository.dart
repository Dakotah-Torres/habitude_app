import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/context.dart';
import 'package:habitude/shared/firestore_paths.dart';

part 'contexts_repository.g.dart';

class ContextsRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  ContextsRepository(this._firestore, {required String uid}) : _uid = uid;

  Stream<List<Context>> watchContexts() {
    return _firestore
        .collection(FirestorePaths.contexts(_uid))
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Context.fromJson(doc.data())).toList(),
        );
  }

  Future<void> addContext(Context context) {
    return _firestore
        .collection(FirestorePaths.contexts(_uid))
        .doc(context.id)
        .set(context.toJson());
  }

  Future<void> updateContext(Context context) {
    return _firestore
        .collection(FirestorePaths.contexts(_uid))
        .doc(context.id)
        .set(context.toJson());
  }

  Future<void> deleteContext(String id) {
    return _firestore
        .collection(FirestorePaths.contexts(_uid))
        .doc(id)
        .delete();
  }
}

@riverpod
ContextsRepository contextsRepository(Ref ref) {
  final uid = ref.watch(currentUserIdProvider);
  return ContextsRepository(FirebaseFirestore.instance, uid: uid);
}

@riverpod
Stream<List<Context>> contextsStream(Ref ref) {
  final repository = ref.watch(contextsRepositoryProvider);
  return repository.watchContexts();
}
