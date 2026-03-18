import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addEmployee({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required int amount,
  }) async {
    String formattedPhone = AppUtils.getFormattedPhoneNumber(
      phoneNumber: phoneNumber,
    );

    final existingUser = await _db
        .collection('users')
        .where('phone', isEqualTo: formattedPhone)
        .get();

    if (existingUser.docs.isNotEmpty) {
      throw Exception("Phone number already exists");
    }

    final empId = await _generateEmployeeId(phoneNumber: phoneNumber);

    WriteBatch batch = _db.batch();
    DocumentReference userRef = _db.collection('users').doc(empId);    

    batch.set(userRef, {
      'empId': empId,
      'createdBy': _auth.currentUser!.uid,
      'updatedBy': _auth.currentUser!.uid,
      'first_name': firstName,
      'last_name': lastName,
      'phone': formattedPhone,
      'allocatedAmount': amount,
      'remaining': amount,
      'status': Status.active.name,
      'role': Roles.employee.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    allocateAmountHistory(
      allocateBy: _auth.currentUser!.uid,
      employeeId: empId,
      amount: amount,
      batch: batch,
    );

    batch.commit();
  }

  Future<List<Employee>> fetchEmployees() async {
    final snapshot = await _db
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .get();

    return snapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList();
  }

  Future allocateAmountHistory({
    required String allocateBy,
    required String employeeId,
    required int amount,
    WriteBatch? batch,
  }) async {
    final DocumentReference allocatedAmountReference = _db
        .collection('allocatedAmount')
        .doc(employeeId);
    final data = {
      'allocatedBy': allocateBy,
      'employeeId': employeeId,
      'amount': amount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (batch != null) {
      batch.set(allocatedAmountReference, data);
    } else {
      await allocatedAmountReference.set(data);
    }
  }

  Future<String> _generateEmployeeId({required String phoneNumber}) async {

    final counterRef = _db.collection('counters').doc('employees');
    final usersRef = _db.collection('users');

    return _db.runTransaction((transaction) async {
      final phoneQuery = await usersRef
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (phoneQuery.docs.isNotEmpty) {
        throw Exception('Phone number already exists');
      }

      // Perform all reads first
      final counterSnap = await transaction.get(counterRef);

      int newId;
      if (!counterSnap.exists) {
        newId = 1;
      } else {
        final lastId = counterSnap.get('lastId') as int;
        newId = lastId + 1;
      }

      final empId = 'EMP${newId.toString().padLeft(3, '0')}';
      final employeeDoc = usersRef.doc(empId);
      final empSnap = await transaction.get(employeeDoc);

      if (empSnap.exists) {
        throw Exception('Employee ID already exists: $empId');
      }

      // Perform all writes after all reads
      if (!counterSnap.exists) {
        transaction.set(counterRef, {'lastId': newId});
      } else {
        transaction.update(counterRef, {'lastId': newId});
      }

      return empId;
    });
  }
}
