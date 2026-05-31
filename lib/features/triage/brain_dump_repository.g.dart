// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brain_dump_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(brainDumpRepository)
final brainDumpRepositoryProvider = BrainDumpRepositoryProvider._();

final class BrainDumpRepositoryProvider
    extends
        $FunctionalProvider<
          BrainDumpRepository,
          BrainDumpRepository,
          BrainDumpRepository
        >
    with $Provider<BrainDumpRepository> {
  BrainDumpRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brainDumpRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brainDumpRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrainDumpRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrainDumpRepository create(Ref ref) {
    return brainDumpRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrainDumpRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrainDumpRepository>(value),
    );
  }
}

String _$brainDumpRepositoryHash() =>
    r'72a7dd67090295e95decac868f662f8314cbe924';

@ProviderFor(brainDumpStream)
final brainDumpStreamProvider = BrainDumpStreamProvider._();

final class BrainDumpStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BrainDumpItem>>,
          List<BrainDumpItem>,
          Stream<List<BrainDumpItem>>
        >
    with
        $FutureModifier<List<BrainDumpItem>>,
        $StreamProvider<List<BrainDumpItem>> {
  BrainDumpStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brainDumpStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brainDumpStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<BrainDumpItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BrainDumpItem>> create(Ref ref) {
    return brainDumpStream(ref);
  }
}

String _$brainDumpStreamHash() => r'087539b2924e0cdc75ee87dd27e450b578379131';

@ProviderFor(brainDumpActiveItems)
final brainDumpActiveItemsProvider = BrainDumpActiveItemsProvider._();

final class BrainDumpActiveItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BrainDumpItem>>,
          List<BrainDumpItem>,
          Stream<List<BrainDumpItem>>
        >
    with
        $FutureModifier<List<BrainDumpItem>>,
        $StreamProvider<List<BrainDumpItem>> {
  BrainDumpActiveItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brainDumpActiveItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brainDumpActiveItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<BrainDumpItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BrainDumpItem>> create(Ref ref) {
    return brainDumpActiveItems(ref);
  }
}

String _$brainDumpActiveItemsHash() =>
    r'd2a1d8905a4ece4b911b05ff51eb16a6bc5da6fa';
