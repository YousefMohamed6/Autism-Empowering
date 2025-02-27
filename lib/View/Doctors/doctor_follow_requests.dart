import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Notification/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../Controller/Const/texts.dart';
import '../../Model/doctor_request_model.dart';

class DoctorRequestsScreen extends StatefulWidget {
  const DoctorRequestsScreen({super.key});

  @override
  State<DoctorRequestsScreen> createState() => _DoctorRequestsScreenState();
}

class _DoctorRequestsScreenState extends State<DoctorRequestsScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> _fetchFollowRequests() {
    return FirebaseFirestore.instance.collection('follow_requests').where('doctorId', isEqualTo: currentUser!.uid).where('status', isEqualTo: 'pending').snapshots();
  }

  void _acceptRequest(String requestId, String patientFcmToken, String doctorName) async {
    await updateFollowRequestStatus(requestId, 'accepted', patientFcmToken, doctorName);
  }

  void _denyRequest(String requestId, String patientFcmToken, String doctorName) async {
    await updateFollowRequestStatus(requestId, 'rejected', patientFcmToken, doctorName);
  }

  updateUserFcmToken() {
    return FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({'fcmToken': OneSignal.User.pushSubscription.id});
  }

  @override
  void initState() {
    updateUserFcmToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Follow Requests'),
        centerTitle: true,
        leading: const BackButtons(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchFollowRequests(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: SpinKitCircle(color: primaryColor, size: 30));
          }

          final followRequests = snapshot.data!.docs.map((doc) {
            return DoctorRequest.fromDocument(doc);
          }).toList();

          if (followRequests.isEmpty) {
            return Center(child: text('No pending follow requests'));
          }

          return ListView.builder(
            itemCount: followRequests.length,
            itemBuilder: (context, index) {
              final request = followRequests[index];
              return ListTile(
                title: text(request.doctorName),
                subtitle: text('Status: ${request.status}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _acceptRequest(request.requestId, request.patientFcmToken, request.doctorName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _denyRequest(request.requestId, request.patientFcmToken, request.doctorName),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> updateFollowRequestStatus(String requestId, String status, String patientFcmToken, String doctorName) async {
  try {
    await FirebaseFirestore.instance.collection('follow_requests').doc(requestId).update({
      'status': status,
    });
    sendNotification(patientFcmToken, '', 'Dr. $doctorName $status Your Request');
    debugPrint('Follow request $requestId updated to $status');
  } catch (e) {
    debugPrint('Error updating follow request: $e');
  }
}
