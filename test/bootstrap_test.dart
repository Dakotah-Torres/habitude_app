import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'helpers/auth_helper.dart';

void main() {
  testWidgets('bootstrap sign-in flow verifies currentUserIdProvider', (
    tester,
  ) async {
    final fakeAuth = FakeAuthRepository();
    addTearDown(fakeAuth.dispose);

    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(fakeAuth)],
    );
    addTearDown(container.dispose);

    // 1. Sign in (as done in main.dart)
    await container.read(authRepositoryProvider).signInAnonymously();

    // 2. Pump the app with the same container
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) {
            final uid = ref.watch(currentUserIdProvider);
            return MaterialApp(home: Scaffold(body: Text(uid)));
          },
        ),
      ),
    );

    expect(find.text('fake_uid'), findsOneWidget);
  });
}
