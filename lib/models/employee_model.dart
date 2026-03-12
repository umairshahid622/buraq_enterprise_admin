import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String empId;
  String firstName;
  String lastName;
  String phone;
  String status;
  String role;

  Employee({
    required this.empId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.status,
    required this.role,
  });

  factory Employee.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return Employee(
      empId: doc.id,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      phone: data['phone'] ?? '',
      status: data['status'] ?? '',
      role: data['role'] ?? '',
    );
  }
}
