// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(trackerRepository)
final trackerRepositoryProvider = TrackerRepositoryProvider._();

final class TrackerRepositoryProvider
    extends
        $FunctionalProvider<
          TrackerRepository,
          TrackerRepository,
          TrackerRepository
        >
    with $Provider<TrackerRepository> {
  TrackerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackerRepositoryHash();

  @$internal
  @override
  $ProviderElement<TrackerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrackerRepository create(Ref ref) {
    return trackerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackerRepository>(value),
    );
  }
}

String _$trackerRepositoryHash() => r'733034312e8d88e7383f06f04cc64996e38ba654';

@ProviderFor(trackersStream)
final trackersStreamProvider = TrackersStreamProvider._();

final class TrackersStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Tracker>>,
          List<Tracker>,
          Stream<List<Tracker>>
        >
    with $FutureModifier<List<Tracker>>, $StreamProvider<List<Tracker>> {
  TrackersStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackersStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackersStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Tracker>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Tracker>> create(Ref ref) {
    return trackersStream(ref);
  }
}

String _$trackersStreamHash() => r'c28fba9f9190146501f7104ebc2c57f59609ed2e';
