import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/images.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class UpdateChildInfoScreen extends StatefulWidget {
  const UpdateChildInfoScreen({super.key});

  @override
  State<UpdateChildInfoScreen> createState() => _UpdateChildInfoScreenState();
}

class _UpdateChildInfoScreenState extends State<UpdateChildInfoScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  final TextEditingController _completedByController = TextEditingController();

  String _gender = 'Male';
  String _bornWithJaundice = 'Yes';
  String _familyHistory = 'Yes';
  String _usedAppBefore = 'Yes';
  bool isLoading = false;
  String _country = 'Middle Eastern';
  Future<void> _updateChildInfo() async {
    setState(() {
      isLoading = true;
    });
    if (!formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
    }

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        isLoading = false;
      });
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('childInfo')
        .doc('info')
        .set({
      'age': _ageController.text,
      'gender': _gender,
      'ethnicity': _ethnicityController.text,
      'bornWithJaundice': _bornWithJaundice,
      'familyHistory': _familyHistory,
      'completedBy': _completedByController.text,
      'country': _country,
      'usedAppBefore': _usedAppBefore,
    });
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Child info updated successfully',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchChildInfo();
  }

  Future<void> _fetchChildInfo() async {
    setState(() {
      isLoading = true;
    });
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        isLoading = false;
      });
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('childInfo')
        .doc('info')
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        _ageController.text = data['age'];
        _ethnicityController.text = data['ethnicity'];
        _completedByController.text = data['completedBy'];
        _country = data['country'];
        _gender = data['gender'];
        _bornWithJaundice = data['bornWithJaundice'];
        _familyHistory = data['familyHistory'];
        _usedAppBefore = data['usedAppBefore'];
      });
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const SpinKitCircle(color: primaryColor, size: 30),
      child: Scaffold(
        appBar: AppBar(
          title: text('Update Child Information'),
          centerTitle: true,
          leading: const BackButtons(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 50.w),
                      text('Age'),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: _ageController,
                    hint: 'Age',
                    keyboardType: TextInputType.number,
                    image: age,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text('Ethnicity'),
                      const Spacer(),
                      Container(
                        width: 150.w,
                        height: 45.h,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: primaryColor.withOpacity(0.3)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            isExpanded: true,
                            value: _country,
                            onChanged: (String? newValue) {
                              setState(() {
                                _country = newValue!;
                              });
                            },
                            items: <String>[
                              'Asian',
                              'Black',
                              'Hispanic',
                              'Latino',
                              'Middle Eastern',
                              'Mixed',
                              'Native',
                              'Others',
                              'Pacifica',
                              'South Asian',
                              'White European',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: text('Gender')),
                      Container(
                        width: 100.w,
                        height: 45.h,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: primaryColor.withOpacity(0.3)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _gender,
                            onChanged: (String? newValue) {
                              setState(() {
                                _gender = newValue!;
                              });
                            },
                            items: <String>['Male', 'Female']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: text('Was your child born with jaundice?')),
                      Container(
                        width: 80.w,
                        height: 45.h,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: primaryColor.withOpacity(0.3)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _bornWithJaundice,
                            onChanged: (String? newValue) {
                              setState(() {
                                _bornWithJaundice = newValue!;
                              });
                            },
                            items: <String>['Yes', 'No']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                          child: text(
                              'Has anyone in the immediate family been diagnosed with autism?')),
                      SizedBox(width: 10.w),
                      Container(
                        width: 80.w,
                        height: 45.h,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: primaryColor.withOpacity(0.3)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            isExpanded: true,
                            value: _familyHistory,
                            onChanged: (String? newValue) {
                              setState(() {
                                _familyHistory = newValue!;
                              });
                            },
                            items: <String>['Yes', 'No']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      SizedBox(width: 50.w),
                      text('Who is completing this test?'),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: _completedByController,
                    hint: 'Who is completing this test?',
                    keyboardType: TextInputType.text,
                    image: account,
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                          child: text(
                              'Have you used this app before for this test and for the same child?')),
                      Container(
                        width: 80.w,
                        height: 45.h,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: primaryColor.withOpacity(0.3)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _usedAppBefore,
                            onChanged: (String? newValue) {
                              setState(() {
                                _usedAppBefore = newValue!;
                              });
                            },
                            items: <String>['Yes', 'No']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120.w,
                        child: CustomButton(
                          onTap: () => Get.back(),
                          title: 'Cancel',
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      SizedBox(
                        width: 120.w,
                        child: CustomButton(
                          onTap: () {
                            _updateChildInfo();
                            Get.back();
                          },
                          title: 'Save',
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
