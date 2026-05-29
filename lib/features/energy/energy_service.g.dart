// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(energyBaseline)
final energyBaselineProvider = EnergyBaselineProvider._();

final class EnergyBaselineProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  EnergyBaselineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'energyBaselineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$energyBaselineHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return energyBaseline(ref);
  }
}

String _$energyBaselineHash() => r'2aa92b535cf1eb712185f736fac0330243d2806c';
