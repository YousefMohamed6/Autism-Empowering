import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorRequest {
  final String requestId;
  final String patientId;
  final String doctorId;
  final String status; // 'pending', 'accepted', 'rejected'
  final String doctorName;
  final String patientName;
  final String doctorFcmToken;
  final String patientFcmToken;

  DoctorRequest({
    required this.requestId,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.doctorName,
    required this.patientName,
    required this.doctorFcmToken,
    required this.patientFcmToken,
  });

  factory DoctorRequest.fromDocument(DocumentSnapshot doc) {
    return DoctorRequest(
      requestId: doc['requestId'],
      patientId: doc['patientId'],
      doctorId: doc['doctorId'],
      status: doc['status'],
      doctorName: doc['doctorName'],
      patientName: doc['patientName'],
      doctorFcmToken: doc['doctorFcmToken'],
      patientFcmToken: doc['patientFcmToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'patientId': patientId,
      'doctorId': doctorId,
      'status': status,
      'doctorName': doctorName,
      'patientName': patientName,
      'doctorFcmToken': doctorFcmToken,
      'patientFcmToken': patientFcmToken,
    };
  }
}
