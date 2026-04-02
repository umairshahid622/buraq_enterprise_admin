import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/models/project_member_model.dart';
import 'package:buraq_enterprise_admin/models/project_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ProjectModel>> fetchProjects() {
    return _db.collection("projects").snapshots().map((snapShot) {
      return snapShot.docs.map((doc) {
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
        'remainingBudget': totalBudgetAllocated,
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
          'allocatedAmount': 0,
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

  Future<void> addRemainingAmountToAllProject() async {
    final collection = FirebaseFirestore.instance.collection('projects');

    final snapshots = await collection.get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshots.docs) {
      final data = doc.data();
      final totalBudgetAllocated = data['totalBudgetAllocated'];

      batch.update(doc.reference, {'remainingBudget': totalBudgetAllocated});      
    }

    batch.commit();
  }

  Stream<int> activeProjectsCountStream(String employeeId) {
    return _db
        .collection('projects')
        .where('employeeIds', arrayContains: employeeId)
        .where('status', isEqualTo: Status.active.name)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<ProjectMember>> fetchProjectMembers(String projectId) {
    return _db
        .collection('project_members')
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map(
          (snapShot) =>
              snapShot.docs.map(ProjectMember.fromSnapshot).toList(),
        );
  }

  Future<void> addProjectMembers({
    required String projectId,
    required List<String> employeeIds,
  }) async {
    final projectRef = _db.collection('projects').doc(projectId);

    await _db.runTransaction((transaction) async {
      final projectSnap = await transaction.get(projectRef);
      if (!projectSnap.exists) {
        throw Exception("Project not found.");
      }

      final project = ProjectModel.fromSnapshot(projectSnap);
      final List<String> existingEmployeeIds = project.employeeIds;

      Map<String, DocumentSnapshot> memberSnaps = {};
      Map<String, DocumentSnapshot> userSnaps = {};

      for (String employeeId in employeeIds) {
        final memberRef =
            _db.collection('project_members').doc('${projectId}_$employeeId');
        final userRef = _db.collection('users').doc(employeeId);
        memberSnaps[employeeId] = await transaction.get(memberRef);
        userSnaps[employeeId] = await transaction.get(userRef);
      }

      List<String> newEmployeeIds = [];

      for (String employeeId in employeeIds) {
        final bool alreadyListed = existingEmployeeIds.contains(employeeId);
        final memberSnap = memberSnaps[employeeId]!;

        if (memberSnap.exists && alreadyListed) {
          throw Exception("Employee already assigned to this project.");
        }

        final memberRef =
            _db.collection('project_members').doc('${projectId}_$employeeId');
        final userRef = _db.collection('users').doc(employeeId);

        transaction.set(memberRef, {
          'projectId': projectId,
          'employeeId': employeeId,
          'allocatedAmount': 0,
          'assignedBy': _auth.currentUser!.uid,
          'updatedBy': _auth.currentUser!.uid,
          'updatedAt': FieldValue.serverTimestamp(),
          'assignedAt': FieldValue.serverTimestamp(),
        });

        if (!alreadyListed) {
          newEmployeeIds.add(employeeId);
        }

        final userSnap = userSnaps[employeeId]!;
        if (userSnap.exists) {
          transaction.update(userRef, {
            'updatedBy': _auth.currentUser!.uid,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      if (newEmployeeIds.isNotEmpty) {
        transaction.update(projectRef, {
          'employeeIds': FieldValue.arrayUnion(newEmployeeIds),
          'updatedBy': _auth.currentUser!.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.update(projectRef, {
          'updatedBy': _auth.currentUser!.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<void> removeProjectMember({
    required String projectId,
    required String employeeId,
  }) async {
    final projectRef = _db.collection('projects').doc(projectId);
    final memberRef =
        _db.collection('project_members').doc('${projectId}_$employeeId');
    final userRef = _db.collection('users').doc(employeeId);

    await _db.runTransaction((transaction) async {
      final projectSnap = await transaction.get(projectRef);
      final memberSnap = await transaction.get(memberRef);
      final userSnap = await transaction.get(userRef);

      if (!projectSnap.exists || !memberSnap.exists) {
        throw Exception("Project member not found.");
      }

      final project = ProjectModel.fromSnapshot(projectSnap);
      final member = ProjectMember.fromSnapshot(memberSnap);
      final int currentRemaining = project.remainingBudget;
      final int allocatedAmount = member.allocatedAmount;

      transaction.update(projectRef, {
        'remainingBudget': currentRemaining + allocatedAmount,
        'employeeIds': FieldValue.arrayRemove([employeeId]),
        'updatedBy': _auth.currentUser!.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.delete(memberRef);

      if (userSnap.exists) {
        final user = Employee.fromSnapshot(userSnap);
        final int userAllocated = user.allocatedAmount;
        final int userRemaining = user.remaining;
        final int newAllocated = userAllocated - allocatedAmount;
        final int newRemaining = userRemaining - allocatedAmount;

        transaction.update(userRef, {
          'allocatedAmount': newAllocated < 0 ? 0 : newAllocated,
          'remaining': newRemaining < 0 ? 0 : newRemaining,
          'updatedBy': _auth.currentUser!.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<void> updateMemberAllocation({
    required String projectId,
    required String employeeId,
    required int newAmount,
  }) async {
    if (newAmount < 0) {
      throw Exception("Amount cannot be negative.");
    }

    final projectRef = _db.collection('projects').doc(projectId);
    final memberRef =
        _db.collection('project_members').doc('${projectId}_$employeeId');
    final userRef = _db.collection('users').doc(employeeId);

    await _db.runTransaction((transaction) async {
      final projectSnap = await transaction.get(projectRef);
      final memberSnap = await transaction.get(memberRef);
      final userSnap = await transaction.get(userRef);

      if (!projectSnap.exists || !memberSnap.exists) {
        throw Exception("Project member not found.");
      }

      final project = ProjectModel.fromSnapshot(projectSnap);
      final member = ProjectMember.fromSnapshot(memberSnap);

      final int currentRemaining = project.remainingBudget;
      final int oldAmount = member.allocatedAmount;
      final int delta = newAmount - oldAmount;

      if (currentRemaining - delta < 0) {
        throw Exception("Insufficient remaining budget for this allocation.");
      }

      transaction.update(projectRef, {
        'remainingBudget': currentRemaining - delta,
        'updatedBy': _auth.currentUser!.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.update(memberRef, {
        'allocatedAmount': newAmount,
        'updatedBy': _auth.currentUser!.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (userSnap.exists) {
        final user = Employee.fromSnapshot(userSnap);
        final int userAllocated = user.allocatedAmount;
        final int userRemaining = user.remaining;

        transaction.update(userRef, {
          'allocatedAmount': userAllocated + delta,
          'remaining': userRemaining + delta,
          'updatedBy': _auth.currentUser!.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}
