import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory Employee.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return Employee(
      id: doc.id,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}
