import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/core/enums/user_type.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/component.dart';
import 'package:autism_empowering/core/utils/constants/images.dart';
import 'package:autism_empowering/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'sign_up.dart';

class ChooseTypeScreen extends StatelessWidget {
  const ChooseTypeScreen({super.key});
  static const String routeName = '/choose-type';
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
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
            Image.asset(AppImages.onBoarding),
            SizedBox(
              height: 80.h,
            ),
            FadeInUp(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
                child: CustomButton(
                  title: localizations.doctor,
                  textColor: Colors.white,
                  onTap: () {
                    context.pushNamed(
                      SignUpView.routeName,
                      extra: UserType.doctor,
                    );
                  },
                  color: AppColors.primaryColor,
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
                  title: localizations.patient,
                  textColor: Colors.white,
                  onTap: () {
                    context.pushNamed(
                      SignUpView.routeName,
                      extra: UserType.patient,
                    );
                  },
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
