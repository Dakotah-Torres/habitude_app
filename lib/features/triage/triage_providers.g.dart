// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'triage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(triageService)
final triageServiceProvider = TriageServiceProvider._();

final class TriageServiceProvider
    extends $FunctionalProvider<TriageService, TriageService, TriageService>
    with $Provider<TriageService> {
  TriageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'triageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$triageServiceHash();

  @$internal
  @override
  $ProviderElement<TriageService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TriageService create(Ref ref) {
    return triageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TriageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TriageService>(value),
    );
  }
}

String _$triageServiceHash() => r'33dbe825e652df5f22b898f142ece7a13ab70266';

@ProviderFor(triagePendingCount)
final triagePendingCountProvider = TriagePendingCountProvider._();

final class TriagePendingCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  TriagePendingCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'triagePendingCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$triagePendingCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return triagePendingCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$triagePendingCountHash() =>
    r'033db8b683ffa378b4505ec97ba7aefdb1581e44';

@ProviderFor(triageQueue)
final triageQueueProvider = TriageQueueProvider._();

final class TriageQueueProvider
    extends
        $FunctionalProvider<
          List<TriageItem>,
          List<TriageItem>,
          List<TriageItem>
        >
    with $Provider<List<TriageItem>> {
  TriageQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'triageQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$triageQueueHash();

  @$internal
  @override
  $ProviderElement<List<TriageItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TriageItem> create(Ref ref) {
    return triageQueue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TriageItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TriageItem>>(value),
    );
  }
}

String _$triageQueueHash() => r'cd3c845b3906866eab4936c4250733cf37f9ae90';
