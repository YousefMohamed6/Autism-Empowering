import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/images.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/View/Check%20Diagonsis/check_by_image.dart';
import 'package:autism_empowering/View/Doctors/doctor_list.dart';
import 'package:autism_empowering/View/clock_game/clock_home_page.dart';
import 'package:autism_empowering/View/drag_and_drob_game/home_game_page.dart';
import 'package:autism_empowering/View/puzzle_game/screens/puzzle/puzzle_starter_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Controller/Auth/auth_service.dart';
import 'Child Info/child_info_screen.dart';
import 'Questionnare/questionare_screen.dart';
import 'Routine/routine_list.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  AuthService authService = Get.put(AuthService());
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isShowDiagnosis = false;
  bool isShowContact = false;
  bool isShowActivitis = false;
  void startQuestionnaire(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('childInfo')
        .doc('info')
        .get();
    if (!doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill out the child info first',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    Get.to(() => const QuestionnaireScreen(), transition: Transition.zoom);
  }

  updateUserFcmToken() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({'fcmToken': OneSignal.User.pushSubscription.id});
  }

  @override
  void initState() {
    updateUserFcmToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            SizedBox(height: 100, width: 100, child: Image.asset(logo)),
            Divider(
              height: 60,
              color: Colors.grey.shade200,
            ),
            CustomDrawerItem(
              onPressed: () {
                Get.to(() => ChildInfoScreen(), transition: Transition.zoom);
              },
              title: 'Child Information',
            ),
            const SizedBox(height: 10),
            CustomDrawerItem(
              onPressed: () {
                Get.to(() => DoctorList(), transition: Transition.zoom);
              },
              title: 'Doctors',
            ),
            const SizedBox(height: 10),
            CustomDrawerItem(
              onPressed: () {
                authService.signOut(context: context);
              },
              title: 'Logout',
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: text('My Account', fontSize: 20),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 120, width: 120, child: Image.asset(logo)),
            const SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: CustomButton(
                title: 'Early Check',
                fontSize: 18.sp,
                onTap: () {
                  setState(() {
                    isShowDiagnosis = !isShowDiagnosis;
                    isShowContact = false;
                  });
                },
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: 15.h),
            Visibility(
              visible: isShowDiagnosis,
              child: Column(
                children: [
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () => startQuestionnaire(context),
                      title: 'With Questionnaire',
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: 10,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () async {
                        // var id = OneSignal.User.pushSubscription.id;

                        Get.to(() => const CheckByImage(),
                            transition: Transition.zoom);
                      },
                      title: 'With Face Image',
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: CustomButton(
                title: 'Activities',
                fontSize: 18.sp,
                onTap: () {
                  setState(() {
                    isShowActivitis = !isShowActivitis;
                    isShowDiagnosis = false;
                  });
                },
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: 15.h),
            Visibility(
              visible: isShowActivitis,
              child: Column(
                children: [
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () {
                        Get.to(() => const PuzzleStarterScreen(),
                            transition: Transition.zoom);
                      },
                      title: 'Puzzle Game',
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: 10,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () {
                        Get.to(() => const HomeGamePage(),
                            transition: Transition.zoom);
                      },
                      title: 'Drag And Drop Game',
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: 10,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () {
                        Get.to(() => const ClockHomePage(),
                            transition: Transition.zoom);
                      },
                      title: 'Clock Game',
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: CustomButton(
                title: 'Other Services',
                fontSize: 18.sp,
                onTap: () {
                  setState(() {
                    isShowContact = !isShowContact;
                    isShowDiagnosis = false;
                  });
                },
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: 15.h),
            Visibility(
              visible: isShowContact,
              child: Column(
                children: [
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () {
                        Get.to(() => DoctorList(), transition: Transition.zoom);
                      },
                      title: 'Contact with  Doctor',
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: 10,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      onTap: () {
                        Get.to(() => RoutineListScreen(),
                            transition: Transition.zoom);
                      },
                      title: 'Make a Routine',
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
