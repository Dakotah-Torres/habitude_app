abstract class FirestorePaths {
  static String goals(String uid) => 'users/$uid/goals';
  static String projects(String uid) => 'users/$uid/projects';
  static String tasks(String uid) => 'users/$uid/tasks';
  static String contexts(String uid) => 'users/$uid/contexts';
  static String taskCompletions(String uid) => 'users/$uid/task_completions';
  static String trackers(String uid) => 'users/$uid/trackers';
}
