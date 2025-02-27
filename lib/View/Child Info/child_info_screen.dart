import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/View/Child%20Info/update_child_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChildInfoScreen extends StatefulWidget {
  const ChildInfoScreen({super.key});

  @override
  State<ChildInfoScreen> createState() => _ChildInfoScreenState();
}

class _ChildInfoScreenState extends State<ChildInfoScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  final TextEditingController _completedByController = TextEditingController();

  String _gender = '';
  String _bornWithJaundice = '';
  String _familyHistory = '';
  String _usedAppBefore = '';

  @override
  void initState() {
    super.initState();
    _fetchChildInfo();
  }

  Future<void> _fetchChildInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('childInfo')
        .doc('info')
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        _ageController.text = data['age'];
        _ethnicityController.text = data['country'];
        _completedByController.text = data['completedBy'];
        _gender = data['gender'];
        _bornWithJaundice = data['bornWithJaundice'];
        _familyHistory = data['familyHistory'];
        _usedAppBefore = data['usedAppBefore'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Child Information'),
        centerTitle: true,
        leading: const BackButtons(),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _fetchChildInfo();
              Get.to(() => const UpdateChildInfoScreen());
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              color: primaryColor.withOpacity(0.3),
              border: Border.all(color: primaryColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              text('Age: ', fontSize: 18),
              SizedBox(height: 5.h),
              text(_ageController.text, fontSize: 16, color: primaryColor),
              SizedBox(height: 10.h),
              text('Gender: ', fontSize: 18),
              SizedBox(height: 5.h),
              text(_gender, fontSize: 16, color: primaryColor),
              SizedBox(height: 10.h),
              text('Ethnicity: ', fontSize: 18),
              SizedBox(height: 5.h),
              text(_ethnicityController.text,
                  fontSize: 16, color: primaryColor),
              SizedBox(height: 10.h),
              text('Was your child born with jaundice: ', fontSize: 18),
              SizedBox(height: 5.h),
              text(_bornWithJaundice, fontSize: 16, color: primaryColor),
              SizedBox(height: 10.h),
              text('Family history of autism: ', fontSize: 18),
              SizedBox(height: 5.h),
              text(_familyHistory, fontSize: 16, color: primaryColor),
              SizedBox(height: 10.h),
              text('Completed by: ', fontSize: 18),
              SizedBox(height: 5.h),
              text(_completedByController.text,
                  fontSize: 16, color: primaryColor),
              SizedBox(height: 10.h),
              text('Used app before: ', fontSize: 18),
              SizedBox(height: 5.h),
              text(_usedAppBefore, fontSize: 16, color: primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
