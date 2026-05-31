// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gamificationRepository)
final gamificationRepositoryProvider = GamificationRepositoryProvider._();

final class GamificationRepositoryProvider
    extends
        $FunctionalProvider<
          GamificationRepository,
          GamificationRepository,
          GamificationRepository
        >
    with $Provider<GamificationRepository> {
  GamificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<GamificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GamificationRepository create(Ref ref) {
    return gamificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GamificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GamificationRepository>(value),
    );
  }
}

String _$gamificationRepositoryHash() =>
    r'c8868013d9fc49bd6c6005f136b26246e67bcb5a';

@ProviderFor(rankUpEvents)
final rankUpEventsProvider = RankUpEventsProvider._();

final class RankUpEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RankUpEvent>>,
          List<RankUpEvent>,
          Stream<List<RankUpEvent>>
        >
    with
        $FutureModifier<List<RankUpEvent>>,
        $StreamProvider<List<RankUpEvent>> {
  RankUpEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rankUpEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rankUpEventsHash();

  @$internal
  @override
  $StreamProviderElement<List<RankUpEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RankUpEvent>> create(Ref ref) {
    return rankUpEvents(ref);
  }
}

String _$rankUpEventsHash() => r'f893c896a7f02581708bacad90c3e3e197d58a8c';

@ProviderFor(unlockedTaskIds)
final unlockedTaskIdsProvider = UnlockedTaskIdsProvider._();

final class UnlockedTaskIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  UnlockedTaskIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unlockedTaskIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unlockedTaskIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    return unlockedTaskIds(ref);
  }
}

String _$unlockedTaskIdsHash() => r'0f7328871cb9ab190a71175e2c2af0d1969f2e71';
