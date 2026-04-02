import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectMember {
  final String projectId;
  final String employeeId;
  final int allocatedAmount;
  final DateTime? assignedAt;
  final DateTime? updatedAt;

  ProjectMember({
    required this.projectId,
    required this.employeeId,
    required this.allocatedAmount,
    this.assignedAt,
    this.updatedAt,
  });

  factory ProjectMember.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectMember(
      projectId: data['projectId'] ?? '',
      employeeId: data['employeeId'] ?? '',
      allocatedAmount: data['allocatedAmount'] ?? 0,
      assignedAt: (data['assignedAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
