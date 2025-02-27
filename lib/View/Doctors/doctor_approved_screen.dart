import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/images.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/View/Doctors/show_parent_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Model/doctor_request_model.dart';
import '../Chat/chat_screen.dart';

class DoctorApprovedScreen extends StatelessWidget {
  const DoctorApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: text('Accepted Requests'),
        ),
        body: Center(
          child: text('No user logged in'),
        ),
      );
    }
    Stream<List<DoctorRequest>> fetchAcceptedFollowRequests(String doctorId) {
      return FirebaseFirestore.instance
          .collection('follow_requests')
          .where('doctorId', isEqualTo: doctorId)
          .where('status', isEqualTo: 'accepted')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DoctorRequest.fromDocument(doc))
              .toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: text('Accepted Requests'),
        centerTitle: true,
        leading: const BackButtons(),
      ),
      body: StreamBuilder<List<DoctorRequest>>(
        stream: fetchAcceptedFollowRequests(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SpinKitCircle(color: primaryColor, size: 30));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: text('No accepted requests'));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return FadeInRight(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 10.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: primaryColor.withOpacity(0.3),
                      border: Border.all(color: primaryColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(request.patientName),
                          text('Request accepted'),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ShowParentDetail(
                                    parentId: request.patientId,
                                  ));
                            },
                            child: SvgPicture.asset(
                              account,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ChatScreen(
                                    serviceID: request.requestId,
                                    reciverID: request.patientId,
                                    requesterName: request.doctorName,
                                    reciverName: request.patientName,
                                    resepFcmToken: request.patientFcmToken,
                                  ));
                            },
                            child: SvgPicture.asset(
                              chat,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
