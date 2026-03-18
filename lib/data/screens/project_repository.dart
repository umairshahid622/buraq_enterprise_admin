import 'package:buraq_enterprise_admin/models/project_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<List<ProjectModel>> fetchProjects () {
    return _db.collection("collectionPath").snapshots().map((snapShot){
      return snapShot.docs.map((doc){
        return ProjectModel.fromSnapshot(doc);
      }).toList();
    });
  }

  Future<void> addProject({
    required String projectName,
    required String projectDiscription,
    required DateTime startDate,
    required DateTime endDate,
    required int totalBudgetAllocated,
    required List<String> employeeIds,
  }) async {
    final projectId = await _generateProjectId();
    final DocumentReference projectRef = _db
        .collection('projects')
        .doc(projectId);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot projectSnap = await transaction.get(projectRef);

      if (projectSnap.exists) {       
        throw Exception("Project '$projectName' already exists!");
      }

      transaction.set(projectRef, {
        'projectId': projectId,
        'employeeIds': employeeIds,
        'projectName': projectName,
        'projectDiscription': projectDiscription,
        'startDate': startDate,
        'endDate': endDate,
        'totalBudgetAllocated': totalBudgetAllocated,
        'status': 'active',
        'createdBy': _auth.currentUser!.uid,
        'updatedBy': _auth.currentUser!.uid,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      for (String employeeId in employeeIds) {
        final memberRef = _db
            .collection('project_members')
            .doc('${projectId}_$employeeId');

        transaction.set(memberRef, {
          'projectId': projectId,
          'employeeId': employeeId,
          'assignedBy': _auth.currentUser!.uid,
          'updatedBy': _auth.currentUser!.uid,
          'updatedAt': FieldValue.serverTimestamp(),
          'assignedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<String> _generateProjectId() async {
    final counterRef = _db.collection('counters').doc('projects');

    return await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      int newId = 1;

      if (snapshot.exists) {
        final data = snapshot.data();
        final lastId = data?['lastId'] ?? 0;
        newId = lastId + 1;
      }

      transaction.set(counterRef, {'lastId': newId}, SetOptions(merge: true));

      return 'PRJ${newId.toString().padLeft(3, '0')}';
    });
  }
}
