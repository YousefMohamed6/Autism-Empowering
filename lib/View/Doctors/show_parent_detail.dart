import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/Model/routine_model.dart';
import 'package:autism_empowering/View/Routine/routine_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowParentDetail extends StatelessWidget {
  const ShowParentDetail({super.key, required this.parentId});
  final String parentId;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: text('Patient Detail', fontSize: 20),
          centerTitle: true,
          surfaceTintColor: Colors.white,
          leading: const BackButtons(),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            tabs: [
              Tab(text: 'Child Info'),
              Tab(text: 'Child Routines'),
              Tab(text: 'Questionnaire'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: ChildInformation(patientID: parentId)),
            Center(child: ChildRoutines(patientID: parentId)),
            Center(child: ChildQuestionnareResult(patientID: parentId)),
          ],
        ),
      ),
    );
  }
}

class ChildInformation extends StatelessWidget {
  const ChildInformation({super.key, required this.patientID});
  final String patientID;
  Stream<QuerySnapshot> fetchChildInformation(String doctorId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(patientID)
        .collection('childInfo')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fetchChildInformation(patientID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitCircle(color: primaryColor, size: 30),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: text(
                  'The parent has not yet complete the child\'s information'));
        }

        final info = snapshot.data!.docs[0];

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            color: primaryColor.withOpacity(0.3),
            border: Border.all(color: primaryColor),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              text('Age: ', fontSize: 18.sp),
              SizedBox(height: 5.h),
              text(info['age'], fontSize: 16.sp, color: primaryColor),
              SizedBox(height: 10.h),
              text('Gender: ', fontSize: 18.sp),
              SizedBox(height: 5.h),
              text(info['gender'], fontSize: 16.sp, color: primaryColor),
              SizedBox(height: 10.h),
              text('Ethnicity: ', fontSize: 18.sp),
              SizedBox(height: 5.h),
              text(info['ethnicity'], fontSize: 16.sp, color: primaryColor),
              SizedBox(height: 10.h),
              text('Was your child born with jaundice: ', fontSize: 18.sp),
              SizedBox(height: 5.h),
              text(info['bornWithJaundice'],
                  fontSize: 16.sp, color: primaryColor),
              SizedBox(height: 10.h),
              text('Family history of autism: ', fontSize: 18.sp),
              SizedBox(height: 5.h),
              text(info['familyHistory'], fontSize: 16.sp, color: primaryColor),
              SizedBox(height: 10.h),
              text('Completed by: ', fontSize: 18.sp),
              SizedBox(height: 5.h),
              text(info['completedBy'], fontSize: 16.sp, color: primaryColor),
              SizedBox(height: 10.h),
              text('Country: ', fontSize: 18.sp),
              SizedBox(height: 5.h),
              text(info['country'], fontSize: 16.sp, color: primaryColor),
              SizedBox(height: 10.h),
              text('Used app before: ', fontSize: 18.sp),
              SizedBox(height: 5.h),
              text(info['usedAppBefore'], fontSize: 16.sp, color: primaryColor),
            ],
          ),
        );
      },
    );
  }
}

class ChildRoutines extends StatelessWidget {
  ChildRoutines({super.key, required this.patientID});
  final RoutineController routineController = Get.put(RoutineController());
  final String patientID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Routines>>(
      stream: routineController.getRoutines(patientID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitCircle(color: primaryColor, size: 30),
          );
        }
        final routines = snapshot.data ?? [];
        if (routines.isEmpty) {
          return Center(
            child: text('The Parent has not make any routine yet'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: routines.length,
          itemBuilder: (ctx, i) {
            return FadeInLeft(
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: primaryColor.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text('Routines Name : ${routines[i].name}'),
                    text(
                        'Routine Time : ${DateFormat.jm().format(routines[i].startDate)}'),
                    text('Notes : ${routines[i].notes}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChildQuestionnareResult extends StatelessWidget {
  const ChildQuestionnareResult({super.key, required this.patientID});
  final String patientID;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(patientID)
          .collection('questionnaire')
          .doc('result')
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitChasingDots(
              color: primaryColor,
              size: 30,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
              child: SizedBox(
                  width: 250.w,
                  child: text(
                      'The parent has not yet completed the questionnaire',
                      textAlign: TextAlign.center)));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        if (data == null || data.isEmpty) {
          return Center(
              child: SizedBox(
                  width: 250.w,
                  child: text(
                      'The parent has not yet completed the questionnaire',
                      textAlign: TextAlign.center)));
        }

        final score = data['score'];
        final List<Map<String, dynamic>> answers = data['answers'] != null
            ? List<Map<String, dynamic>>.from(data['answers'])
            : [];

        return Column(
          children: [
            SizedBox(height: 20.h),
            text('Score: $score', fontSize: 20.sp),
            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final answer = answers[index];
                  return FadeInRight(
                    child: ListTile(
                      title: text(answer['question']),
                      subtitle: text(
                        answer['selectedAnswer'],
                        color: primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
