// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tasksRepository)
final tasksRepositoryProvider = TasksRepositoryProvider._();

final class TasksRepositoryProvider
    extends
        $FunctionalProvider<TasksRepository, TasksRepository, TasksRepository>
    with $Provider<TasksRepository> {
  TasksRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksRepositoryHash();

  @$internal
  @override
  $ProviderElement<TasksRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TasksRepository create(Ref ref) {
    return tasksRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TasksRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TasksRepository>(value),
    );
  }
}

String _$tasksRepositoryHash() => r'ae99d7ebcc029df8e39129b0bfbd7011f4d3574a';

@ProviderFor(tasksStream)
final tasksStreamProvider = TasksStreamProvider._();

final class TasksStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  TasksStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return tasksStream(ref);
  }
}

String _$tasksStreamHash() => r'5a6b23d120d3ca03675772bd3e7436464ee1fa47';

@ProviderFor(tasksByParentStream)
final tasksByParentStreamProvider = TasksByParentStreamFamily._();

final class TasksByParentStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  TasksByParentStreamProvider._({
    required TasksByParentStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tasksByParentStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksByParentStreamHash();

  @override
  String toString() {
    return r'tasksByParentStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return tasksByParentStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksByParentStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksByParentStreamHash() =>
    r'a3375e039273c1159c454d1e5926ae0661f762c5';

final class TasksByParentStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  TasksByParentStreamFamily._()
    : super(
        retry: null,
        name: r'tasksByParentStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TasksByParentStreamProvider call(String parentId) =>
      TasksByParentStreamProvider._(argument: parentId, from: this);

  @override
  String toString() => r'tasksByParentStreamProvider';
}

@ProviderFor(taskStream)
final taskStreamProvider = TaskStreamFamily._();

final class TaskStreamProvider
    extends $FunctionalProvider<AsyncValue<Task>, Task, Stream<Task>>
    with $FutureModifier<Task>, $StreamProvider<Task> {
  TaskStreamProvider._({
    required TaskStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskStreamHash();

  @override
  String toString() {
    return r'taskStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Task> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Task> create(Ref ref) {
    final argument = this.argument as String;
    return taskStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskStreamHash() => r'fd165365a7bc5530ff5d28c5f02cdee8e14714e3';

final class TaskStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Task>, String> {
  TaskStreamFamily._()
    : super(
        retry: null,
        name: r'taskStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskStreamProvider call(String id) =>
      TaskStreamProvider._(argument: id, from: this);

  @override
  String toString() => r'taskStreamProvider';
}
