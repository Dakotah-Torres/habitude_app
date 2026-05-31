// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TimerNotifier)
final timerNotifierProvider = TimerNotifierProvider._();

final class TimerNotifierProvider
    extends $NotifierProvider<TimerNotifier, TimerState> {
  TimerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerNotifierHash();

  @$internal
  @override
  TimerNotifier create() => TimerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerState>(value),
    );
  }
}

String _$timerNotifierHash() => r'78f0a5b0cc0abce2a9a4e14dd39d00a5301b4fee';

abstract class _$TimerNotifier extends $Notifier<TimerState> {
  TimerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimerState, TimerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimerState, TimerState>,
              TimerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
