// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contexts_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contextsRepository)
final contextsRepositoryProvider = ContextsRepositoryProvider._();

final class ContextsRepositoryProvider
    extends
        $FunctionalProvider<
          ContextsRepository,
          ContextsRepository,
          ContextsRepository
        >
    with $Provider<ContextsRepository> {
  ContextsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contextsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contextsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContextsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContextsRepository create(Ref ref) {
    return contextsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContextsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContextsRepository>(value),
    );
  }
}

String _$contextsRepositoryHash() =>
    r'083b7cfcdd2c47a121ee7584c5e2ee6698c7ee0f';

@ProviderFor(contextsStream)
final contextsStreamProvider = ContextsStreamProvider._();

final class ContextsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Context>>,
          List<Context>,
          Stream<List<Context>>
        >
    with $FutureModifier<List<Context>>, $StreamProvider<List<Context>> {
  ContextsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contextsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contextsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Context>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Context>> create(Ref ref) {
    return contextsStream(ref);
  }
}

String _$contextsStreamHash() => r'4f36a03b635b3c5c0b989ca6f6b1d4ab3eeb9def';
