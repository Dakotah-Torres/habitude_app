import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'helpers/auth_helper.dart';

void main() {
  group('FakeAuthRepository', () {
    test('currentUserId throws when not signed in', () {
      final repository = FakeAuthRepository();
      addTearDown(repository.dispose);

      expect(
        () => repository.currentUserId,
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'not_signed_in',
          ),
        ),
      );
    });

    test('signInAnonymously sets uid and currentUserId returns it', () async {
      final repository = FakeAuthRepository();
      addTearDown(repository.dispose);

      await repository.signInAnonymously();
      expect(repository.currentUserId, equals('fake_uid'));
    });

    test('signInAnonymously is a no-op if already signed in', () async {
      final repository = FakeAuthRepository(initialUid: 'abc');
      addTearDown(repository.dispose);

      await repository.signInAnonymously();
      expect(repository.currentUserId, equals('abc'));
    });

    test('authStateChanges emits null, then a user after sign-in', () async {
      final repository = FakeAuthRepository();
      addTearDown(repository.dispose);
      final emittedUserIds = <String?>[];

      final subscription = repository.authStateChanges.listen(
        (user) => emittedUserIds.add(user?.uid),
      );
      addTearDown(subscription.cancel);

      await Future<void>.delayed(Duration.zero);
      await repository.signInAnonymously();
      await Future<void>.delayed(Duration.zero);

      expect(emittedUserIds, equals([null, 'fake_uid']));
    });
  });

  group('currentUserIdProvider', () {
    test('returns the UID from the repository', () {
      final repository = FakeAuthRepository(initialUid: 'test123');
      addTearDown(repository.dispose);

      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      expect(container.read(currentUserIdProvider), equals('test123'));
    });
  });
}
