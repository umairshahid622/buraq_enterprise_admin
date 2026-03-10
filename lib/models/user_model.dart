class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String role;

  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phoneNumber: map['phone'] ?? '',
      role: map['role'] ?? '',
    );
  }

  bool get isEmpty => uid.isEmpty;
}
