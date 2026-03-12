import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addEmployee({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final existingUser = await _db
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .get();

    if (existingUser.docs.isNotEmpty) {
      throw Exception("Phone number already exists");
    }

    final empId = await _generateEmployeeId(phoneNumber: phoneNumber);

    await _db.collection('users').doc(empId).set({
      'empId': empId,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phoneNumber,
      'status': EmployeeStatus.active.name,
      'role': Roles.employee.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Employee>> fetchEmployees() async {
    final snapshot = await _db
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .get();

    return snapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList();
  }

  Future<String> _generateEmployeeId({required String phoneNumber}) async {
    final db = FirebaseFirestore.instance;

    final counterRef = db.collection('counters').doc('employees');
    final usersRef = db.collection('users');

    return db.runTransaction((transaction) async {
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
