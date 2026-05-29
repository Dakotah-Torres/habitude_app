import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/shared/firestore_paths.dart';

void main() {
  test('FirestorePaths returns expected strings for uid = "abc123"', () {
    const uid = 'abc123';
    expect(FirestorePaths.goals(uid), equals('users/abc123/goals'));
    expect(FirestorePaths.projects(uid), equals('users/abc123/projects'));
    expect(FirestorePaths.tasks(uid), equals('users/abc123/tasks'));
    expect(FirestorePaths.contexts(uid), equals('users/abc123/contexts'));
  });
}
