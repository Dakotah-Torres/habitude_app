// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectsRepository)
final projectsRepositoryProvider = ProjectsRepositoryProvider._();

final class ProjectsRepositoryProvider
    extends
        $FunctionalProvider<
          ProjectsRepository,
          ProjectsRepository,
          ProjectsRepository
        >
    with $Provider<ProjectsRepository> {
  ProjectsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProjectsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectsRepository create(Ref ref) {
    return projectsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectsRepository>(value),
    );
  }
}

String _$projectsRepositoryHash() =>
    r'239698825a412bed6f68e44817748b9cccde0825';

@ProviderFor(projectsStream)
final projectsStreamProvider = ProjectsStreamProvider._();

final class ProjectsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Project>>,
          List<Project>,
          Stream<List<Project>>
        >
    with $FutureModifier<List<Project>>, $StreamProvider<List<Project>> {
  ProjectsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Project>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Project>> create(Ref ref) {
    return projectsStream(ref);
  }
}

String _$projectsStreamHash() => r'5519bc9bfc90261c519c42c3ffda8014a26f51fd';

@ProviderFor(projectsByGoalStream)
final projectsByGoalStreamProvider = ProjectsByGoalStreamFamily._();

final class ProjectsByGoalStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Project>>,
          List<Project>,
          Stream<List<Project>>
        >
    with $FutureModifier<List<Project>>, $StreamProvider<List<Project>> {
  ProjectsByGoalStreamProvider._({
    required ProjectsByGoalStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectsByGoalStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectsByGoalStreamHash();

  @override
  String toString() {
    return r'projectsByGoalStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Project>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Project>> create(Ref ref) {
    final argument = this.argument as String;
    return projectsByGoalStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectsByGoalStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectsByGoalStreamHash() =>
    r'b0836dae1ed5863cd87af382d6db592947f713c6';

final class ProjectsByGoalStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Project>>, String> {
  ProjectsByGoalStreamFamily._()
    : super(
        retry: null,
        name: r'projectsByGoalStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectsByGoalStreamProvider call(String goalId) =>
      ProjectsByGoalStreamProvider._(argument: goalId, from: this);

  @override
  String toString() => r'projectsByGoalStreamProvider';
}

@ProviderFor(projectStream)
final projectStreamProvider = ProjectStreamFamily._();

final class ProjectStreamProvider
    extends $FunctionalProvider<AsyncValue<Project>, Project, Stream<Project>>
    with $FutureModifier<Project>, $StreamProvider<Project> {
  ProjectStreamProvider._({
    required ProjectStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectStreamHash();

  @override
  String toString() {
    return r'projectStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Project> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Project> create(Ref ref) {
    final argument = this.argument as String;
    return projectStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectStreamHash() => r'bcee592da7eea035b02ef8cfb16f5d90e0f44877';

final class ProjectStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Project>, String> {
  ProjectStreamFamily._()
    : super(
        retry: null,
        name: r'projectStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectStreamProvider call(String id) =>
      ProjectStreamProvider._(argument: id, from: this);

  @override
  String toString() => r'projectStreamProvider';
}
