import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/Model/doctor_model.dart';
import 'package:autism_empowering/View/Chat/chat_screen.dart';
import 'package:autism_empowering/core/services/one_Signal_service.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/images.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../Model/doctor_request_model.dart';
import '../../core/utils/constants/component.dart';
import '../../main.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  Future<List<Doctors>> _fetchFollowers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Doctor')
          .get();
      return querySnapshot.docs.map((doc) {
        return Doctors.fromDocument(doc);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching followers: $e');
      return [];
    }
  }

  final String? token = pref!.getString('userToken');

  bool isSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: text('Doctors', fontSize: 20),
        centerTitle: true,
        surfaceTintColor: Colors.white,
        leading: const BackButtons(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: FutureBuilder<List<Doctors>>(
          future: _fetchFollowers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      SpinKitCircle(color: AppColors.primaryColor, size: 30));
            } else if (snapshot.hasError) {
              return Center(child: text('حدث خطأ: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: text('There is No Doctors', fontSize: 16));
            } else {
              List<Doctors> followers = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  Doctors follower = followers[index];
                  return FadeInLeft(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryColor.withOpacity(0.3)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(follower.name),
                              text(follower.email),
                              text(follower.notes),
                            ],
                          ),
                          FollowButton(doctorId: follower.id),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class FollowButton extends StatefulWidget {
  const FollowButton({super.key, required this.doctorId});
  final String doctorId;
  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  DoctorRequest? _followRequest;
  bool _isLoading = true;

  Future<void> sendFollowRequest(String doctorId) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    String requestId = const Uuid().v4();

    // Retrieve user details
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    String patientName = userSnapshot['name'];
    String patientFcmToken = userSnapshot['fcmToken'];

    // Retrieve doctor details
    DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(doctorId)
        .get();
    String doctorName = doctorSnapshot['name'];
    String doctorFcmToken = doctorSnapshot['fcmToken'];

    await FirebaseFirestore.instance
        .collection('follow_requests')
        .doc(requestId)
        .set({
      'requestId': requestId,
      'patientId': currentUser.uid,
      'doctorId': doctorId,
      'status': 'pending',
      'doctorName': doctorName,
      'patientName': patientName,
      'doctorFcmToken': doctorFcmToken,
      'patientFcmToken': patientFcmToken,
    });
    OneSignalService.sendNotification(
      fcmToken: doctorFcmToken,
      message: '',
      senderName: '$patientName Send Request to Following',
    );
    debugPrint('Follow request sent successfully');
  }

  Future<void> removeFollowRequest(
      String requestId, String doctorFcmToken, String patientName) async {
    await FirebaseFirestore.instance
        .collection('follow_requests')
        .doc(requestId)
        .delete();
    OneSignalService.sendNotification(
      fcmToken: doctorFcmToken,
      message: '',
      senderName: '$patientName Unfollowing',
    );

    debugPrint('Follow request $requestId removed');
  }

  Future<DoctorRequest?> fetchFollowRequestStatus(String doctorId) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return null;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('follow_requests')
        .where('patientId', isEqualTo: currentUser.uid)
        .where('doctorId', isEqualTo: doctorId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return DoctorRequest.fromDocument(querySnapshot.docs.first);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFollowRequestStatus();
  }

  Future<void> _fetchFollowRequestStatus() async {
    DoctorRequest? followRequest =
        await fetchFollowRequestStatus(widget.doctorId);
    setState(() {
      _followRequest = followRequest;
      _isLoading = false;
    });
  }

  Future<void> _sendFollowRequest() async {
    setState(() {
      _isLoading = true;
    });
    await sendFollowRequest(widget.doctorId);
    await _fetchFollowRequestStatus();
  }

  Future<void> _removeFollowRequest(
      String doctorFcmToken, String patientName) async {
    if (_followRequest != null) {
      setState(() {
        _isLoading = true;
      });
      await removeFollowRequest(
          _followRequest!.requestId, doctorFcmToken, patientName);
      await _fetchFollowRequestStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SpinKitCircle(color: AppColors.primaryColor, size: 30);
    }

    if (_followRequest == null) {
      return ElevatedButton(
        onPressed: _sendFollowRequest,
        child: text('Follow'),
      );
    }

    if (_followRequest!.status == 'pending') {
      return ElevatedButton(
        onPressed: () {
          _removeFollowRequest(
              _followRequest!.doctorFcmToken, _followRequest!.patientName);
        },
        child: text('Pending'),
      );
    }

    if (_followRequest!.status == 'accepted') {
      return Row(
        children: [
          SizedBox(
            width: 100.w,
            height: 30.h,
            child: CustomButton(
              onTap: () {
                _removeFollowRequest(_followRequest!.doctorFcmToken,
                    _followRequest!.patientName);
              },
              title: 'UnFollow',
              fontSize: 14.sp,
              textColor: Colors.white,
            ),
          ),
          IconButton(
              onPressed: () {
                Get.to(() => ChatScreen(
                      serviceID: _followRequest!.requestId,
                      reciverID: _followRequest!.doctorId,
                      requesterName: _followRequest!.patientName,
                      reciverName: _followRequest!.doctorName,
                      resepFcmToken: _followRequest!.doctorFcmToken,
                    ));
              },
              icon: SvgPicture.asset(
                AppImages.chat,
                color: AppColors.primaryColor,
              )),
        ],
      );
    }

    return ElevatedButton(
      onPressed: _sendFollowRequest,
      child: text('Follow'),
    );
  }
}
