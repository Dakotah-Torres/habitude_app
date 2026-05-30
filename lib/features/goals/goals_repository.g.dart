// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(goalsRepository)
final goalsRepositoryProvider = GoalsRepositoryProvider._();

final class GoalsRepositoryProvider
    extends
        $FunctionalProvider<GoalsRepository, GoalsRepository, GoalsRepository>
    with $Provider<GoalsRepository> {
  GoalsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsRepositoryHash();

  @$internal
  @override
  $ProviderElement<GoalsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoalsRepository create(Ref ref) {
    return goalsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalsRepository>(value),
    );
  }
}

String _$goalsRepositoryHash() => r'8e53a7160264c36448fab69810836fa76cc57d82';

@ProviderFor(goalsStream)
final goalsStreamProvider = GoalsStreamProvider._();

final class GoalsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Goal>>,
          List<Goal>,
          Stream<List<Goal>>
        >
    with $FutureModifier<List<Goal>>, $StreamProvider<List<Goal>> {
  GoalsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Goal>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Goal>> create(Ref ref) {
    return goalsStream(ref);
  }
}

String _$goalsStreamHash() => r'28e240f9ac3ca97be8b62cc1d340003591cb2a79';

@ProviderFor(goalStream)
final goalStreamProvider = GoalStreamFamily._();

final class GoalStreamProvider
    extends $FunctionalProvider<AsyncValue<Goal>, Goal, Stream<Goal>>
    with $FutureModifier<Goal>, $StreamProvider<Goal> {
  GoalStreamProvider._({
    required GoalStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'goalStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$goalStreamHash();

  @override
  String toString() {
    return r'goalStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Goal> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Goal> create(Ref ref) {
    final argument = this.argument as String;
    return goalStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$goalStreamHash() => r'a9aebb6ef8ab92c1e3300b296f9d41f7a0980cf6';

final class GoalStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Goal>, String> {
  GoalStreamFamily._()
    : super(
        retry: null,
        name: r'goalStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GoalStreamProvider call(String id) =>
      GoalStreamProvider._(argument: id, from: this);

  @override
  String toString() => r'goalStreamProvider';
}
