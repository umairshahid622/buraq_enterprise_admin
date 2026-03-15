import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
    String empId;
    String createdBy;
    String updatedBy;
    String firstName;
    String lastName;
    String phone;
    int allocatedAmount;
    int remaining;
    String status;
    String role;
    DateTime createdAt;
    DateTime updatedAt;

  Employee({
        required this.empId,
        required this.createdBy,
        required this.updatedBy,
        required this.firstName,
        required this.lastName,
        required this.phone,
        required this.allocatedAmount,
        required this.remaining,
        required this.status,
        required this.role,
        required this.createdAt,
        required this.updatedAt,
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
      allocatedAmount: data['allocatedAmount'] ?? 0,
      remaining: data['remaining'] ?? 0,
      createdBy: data['createdBy'] ?? '',
      updatedBy: data['updatedBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
