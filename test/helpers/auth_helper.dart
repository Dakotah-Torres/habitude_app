import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/shared/auth_repository.dart';

class FakeUser extends Fake implements User {
  @override
  final String uid;
  FakeUser(this.uid);
}

class FakeAuthRepository implements AuthRepository {
  String? _uid;
  final _controller = StreamController<User?>.broadcast();

  FakeAuthRepository({String? initialUid}) : _uid = initialUid;

  @override
  Future<void> signInAnonymously() async {
    if (_uid == null) {
      _uid = 'fake_uid';
      _controller.add(FakeUser(_uid!));
    }
  }

  @override
  String get currentUserId {
    if (_uid == null) {
      throw StateError('not_signed_in');
    }
    return _uid!;
  }

  @override
  Stream<User?> get authStateChanges async* {
    yield _uid != null ? FakeUser(_uid!) : null;
    yield* _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
