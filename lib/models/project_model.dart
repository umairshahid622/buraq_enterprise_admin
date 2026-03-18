import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String projectId;
  final String projectName;
  final String projectDiscription; // Matching your current DB key
  final DateTime startDate;
  final DateTime endDate;
  final int totalBudgetAllocated;
  final int remainingBudget;
  final String status;
  final String createdBy;
  final String updatedBy;
  final List<String> employeeIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.projectDiscription,
    required this.startDate,
    required this.endDate,
    required this.totalBudgetAllocated,
    required this.remainingBudget,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
    required this.employeeIds,
    this.createdAt,
    this.updatedAt,
  });

  factory ProjectModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ProjectModel(
      projectId: data['projectId'] ?? '',
      projectName: data['projectName'] ?? '',
      projectDiscription: data['projectDiscription'] ?? '',      
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      totalBudgetAllocated: data['totalBudgetAllocated'] ?? 0,
      remainingBudget: data['remainingBudget'] ?? 0,
      status: data['status'] ?? 'active',
      createdBy: data['createdBy'] ?? '',
      updatedBy: data['updatedBy'] ?? '',
      employeeIds: List<String>.from(data['employeeIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'projectDiscription': projectDiscription,
      'startDate': startDate,
      'endDate': endDate,
      'totalBudgetAllocated': totalBudgetAllocated,
      'remainingBudget': remainingBudget,
      'status': status,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'employeeIds': employeeIds,
      'updatedAt': FieldValue.serverTimestamp(),
      // Note: createdAt is usually set once on the server side
    };
  }
}