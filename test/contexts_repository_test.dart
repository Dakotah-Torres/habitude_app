import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/context.dart';
import 'package:habitude/shared/contexts_repository.dart';
import 'helpers/auth_helper.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ContextsRepository repository;
  late FakeAuthRepository fakeAuth;
  const testUid = 'fake_uid';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeAuth = FakeAuthRepository(initialUid: testUid);
    addTearDown(fakeAuth.dispose);
    repository = ContextsRepository(fakeFirestore, uid: testUid);
  });

  group('ContextsRepository', () {
    test('watchContexts emits empty list initially', () async {
      final contexts = await repository.watchContexts().first;
      expect(contexts, isEmpty);
    });

    test('addContext then watchContexts emits the context', () async {
      final context = Context(
        id: 'c1',
        name: 'Context Name',
        colorHex: 'FF6B35',
      );

      await repository.addContext(context);
      final contexts = await repository.watchContexts().first;

      expect(contexts, hasLength(1));
      expect(contexts.first, equals(context));
    });

    test('updateContext changes the context name', () async {
      final context = Context(id: 'c1', name: 'Old Name', colorHex: 'FF6B35');

      await repository.addContext(context);
      await repository.updateContext(context.copyWith(name: 'New Name'));

      final contexts = await repository.watchContexts().first;
      expect(contexts.first.name, equals('New Name'));
    });

    test('deleteContext removes the context', () async {
      final context = Context(
        id: 'c1',
        name: 'Context Name',
        colorHex: 'FF6B35',
      );

      await repository.addContext(context);
      await repository.deleteContext(context.id);

      final contexts = await repository.watchContexts().first;
      expect(contexts, isEmpty);
    });

    test('preserves exact colorHex string', () async {
      final context = Context(
        id: 'c1',
        name: 'Context Name',
        colorHex: 'FF6B35',
      );

      await repository.addContext(context);
      final contexts = await repository.watchContexts().first;
      expect(contexts.first.colorHex, equals('FF6B35'));
    });

    group('Providers', () {
      test('contextsStreamProvider emits values from repository', () async {
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuth),
            contextsRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final subscription = container.listen(
          contextsStreamProvider,
          (prev, next) {},
        );

        final context = Context(
          id: 'c1',
          name: 'Stream Test',
          colorHex: 'FF6B35',
        );

        var contexts = await container.read(contextsStreamProvider.future);
        expect(contexts, isEmpty);

        await repository.addContext(context);

        contexts = await container.read(contextsStreamProvider.future);
        expect(contexts, hasLength(1));
        expect(contexts.first.name, equals('Stream Test'));

        subscription.close();
      });
    });
  });
}
