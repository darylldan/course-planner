import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String?> uploadSharedCourse(Map<String, dynamic> sharedCourse) async {
    try {
      final dataWithToken = {
        ...sharedCourse,
        'secretToken': 'ISKOLAR_NG_BAYAN', // If using security rules
      };
      final docRef = await db.collection("sharing").add(dataWithToken);
      return docRef.id;
    } on FirebaseException catch (e) {
      debugPrint('Failed with error ${e.code}: ${e.message}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> downloadCourse(String id) async {
    try {
      final snapshot = await db.collection("sharing").doc(id).get();
      return snapshot
          .data(); // Returns the document data (or null if not found)
    } on FirebaseException catch (e) {
      debugPrint('Error downloading course: ${e.message}');
      return null;
    }
  }
}
