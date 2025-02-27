import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isFollower(String patientId, String followerId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('follow_requests').where('patientId', isEqualTo: patientId).where('followerId', isEqualTo: followerId).where('status', isEqualTo: 'accepted').get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking follower status: $e');
      return false;
    }
  }
}
