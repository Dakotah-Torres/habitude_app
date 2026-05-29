import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<void> signInAnonymously();
  String get currentUserId;
  Stream<User?> get authStateChanges;
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository(this._auth);

  @override
  Future<void> signInAnonymously() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  @override
  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('not_signed_in');
    }
    return user.uid;
  }

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository(FirebaseAuth.instance);
}

@riverpod
String currentUserId(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.currentUserId;
}
