import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'package:habitude/shared/firestore_paths.dart';

part 'projects_repository.g.dart';

class ProjectsRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  ProjectsRepository(this._firestore, {required String uid}) : _uid = uid;

  Stream<List<Project>> watchProjects() {
    return _firestore
        .collection(FirestorePaths.projects(_uid))
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList(),
        );
  }

  Stream<List<Project>> watchProjectsByGoal(String goalId) {
    return _firestore
        .collection(FirestorePaths.projects(_uid))
        .where('goalId', isEqualTo: goalId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList(),
        );
  }

  Future<void> addProject(Project project) {
    return _firestore
        .collection(FirestorePaths.projects(_uid))
        .doc(project.id)
        .set(project.toJson());
  }

  Future<void> updateProject(Project project) {
    return _firestore
        .collection(FirestorePaths.projects(_uid))
        .doc(project.id)
        .set(project.toJson());
  }

  Future<void> deleteProject(String id) {
    return _firestore
        .collection(FirestorePaths.projects(_uid))
        .doc(id)
        .delete();
  }
}

@riverpod
ProjectsRepository projectsRepository(Ref ref) {
  final uid = ref.watch(currentUserIdProvider);
  return ProjectsRepository(FirebaseFirestore.instance, uid: uid);
}

@riverpod
Stream<List<Project>> projectsStream(Ref ref) {
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.watchProjects();
}
