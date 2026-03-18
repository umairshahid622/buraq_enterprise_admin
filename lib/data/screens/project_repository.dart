import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addProject() async {}

  Future<String> generateProjectId() async {
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
