// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskConsistencyRatios)
final taskConsistencyRatiosProvider = TaskConsistencyRatiosProvider._();

final class TaskConsistencyRatiosProvider
    extends
        $FunctionalProvider<
          Map<String, double>,
          Map<String, double>,
          Map<String, double>
        >
    with $Provider<Map<String, double>> {
  TaskConsistencyRatiosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskConsistencyRatiosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskConsistencyRatiosHash();

  @$internal
  @override
  $ProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, double> create(Ref ref) {
    return taskConsistencyRatios(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, double>>(value),
    );
  }
}

String _$taskConsistencyRatiosHash() =>
    r'7ba42a52fa13ffb6c3a37c12187520f1b419efcb';

@ProviderFor(currentRank)
final currentRankProvider = CurrentRankProvider._();

final class CurrentRankProvider extends $FunctionalProvider<Rank, Rank, Rank>
    with $Provider<Rank> {
  CurrentRankProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentRankProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentRankHash();

  @$internal
  @override
  $ProviderElement<Rank> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Rank create(Ref ref) {
    return currentRank(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Rank value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Rank>(value),
    );
  }
}

String _$currentRankHash() => r'2e0dde6c6bed2b384a9d2f3ff78206ba265b0851';

@ProviderFor(adjustedEnergyBaseline)
final adjustedEnergyBaselineProvider = AdjustedEnergyBaselineProvider._();

final class AdjustedEnergyBaselineProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  AdjustedEnergyBaselineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adjustedEnergyBaselineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adjustedEnergyBaselineHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return adjustedEnergyBaseline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$adjustedEnergyBaselineHash() =>
    r'4fcfa513f699dbc13238c34efd823f5ca4619368';

@ProviderFor(pendingCapacityUnlocks)
final pendingCapacityUnlocksProvider = PendingCapacityUnlocksProvider._();

final class PendingCapacityUnlocksProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  PendingCapacityUnlocksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingCapacityUnlocksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingCapacityUnlocksHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return pendingCapacityUnlocks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$pendingCapacityUnlocksHash() =>
    r'e5378cf337fc90da654ba92e7e286020496b454d';
