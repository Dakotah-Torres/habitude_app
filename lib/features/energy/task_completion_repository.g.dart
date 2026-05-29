// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_completion_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskCompletionRepository)
final taskCompletionRepositoryProvider = TaskCompletionRepositoryProvider._();

final class TaskCompletionRepositoryProvider
    extends
        $FunctionalProvider<
          TaskCompletionRepository,
          TaskCompletionRepository,
          TaskCompletionRepository
        >
    with $Provider<TaskCompletionRepository> {
  TaskCompletionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskCompletionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskCompletionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskCompletionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskCompletionRepository create(Ref ref) {
    return taskCompletionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskCompletionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskCompletionRepository>(value),
    );
  }
}

String _$taskCompletionRepositoryHash() =>
    r'00fee6e7b8aecd47a17918e11cf2c5eea94f988c';

@ProviderFor(taskCompletionsStream)
final taskCompletionsStreamProvider = TaskCompletionsStreamProvider._();

final class TaskCompletionsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TaskCompletion>>,
          List<TaskCompletion>,
          Stream<List<TaskCompletion>>
        >
    with
        $FutureModifier<List<TaskCompletion>>,
        $StreamProvider<List<TaskCompletion>> {
  TaskCompletionsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskCompletionsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskCompletionsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<TaskCompletion>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TaskCompletion>> create(Ref ref) {
    return taskCompletionsStream(ref);
  }
}

String _$taskCompletionsStreamHash() =>
    r'5907390f690b6fb7ee6249640c42a519b39f04c2';
