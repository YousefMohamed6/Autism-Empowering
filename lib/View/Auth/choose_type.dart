import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'sign_up_doctor.dart';
import 'sign_up_parent.dart';

class ChooseTypeScreen extends StatelessWidget {
  const ChooseTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.asset(onBoarding),
            SizedBox(
              height: 80.h,
            ),
            FadeInUp(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
                child: CustomButton(
                  title: 'Doctor',
                  textColor: Colors.white,
                  onTap: () {
                    Get.to(() => SignUpDoctorScreen(),
                        transition: Transition.zoom);
                  },
                  color: primaryColor.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            FadeInDown(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
                child: CustomButton(
                  title: 'Parent',
                  textColor: Colors.white,
                  onTap: () {
                    Get.to(() => SignUpParentScreen(),
                        transition: Transition.zoom);
                  },
                  color: primaryColor.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
