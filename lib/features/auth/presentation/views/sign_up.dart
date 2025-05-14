import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/core/enums/user_type.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/component.dart';
import 'package:autism_empowering/core/utils/constants/images.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:autism_empowering/features/auth/presentation/manager/auth_cubit.dart';
import 'package:autism_empowering/generated/app_localizations.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import 'login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});
  static String routeName = '/sign-up';
  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final appLocalization = AppLocalizations.of(context)!;
    return BlurryModalProgressHUD(
      inAsyncCall: false,
      progressIndicator: const SpinKitCircle(
        color: AppColors.primaryColor,
        size: 30,
      ),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              FadeInRight(
                child: Image.asset(
                  AppImages.logo,
                  height: 200.h,
                  width: 200.w,
                ),
              ),
              SizedBox(height: 20.h),
              FadeInLeft(
                  child: Center(
                      child: text(
                          '${appLocalization.signup_as}${cubit.userRole == UserType.doctor ? appLocalization.doctor : appLocalization.patient}',
                          fontSize: 25.sp))),
              SizedBox(height: 20.h),
              FadeInRight(
                child: CustomTextField(
                  controller: cubit.nameTextController,
                  keyboardType: TextInputType.name,
                  image: AppImages.account,
                  hint: appLocalization.name,
                ),
              ),
              SizedBox(height: 16.h),
              FadeInLeft(
                child: CustomTextField(
                  controller: cubit.emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  image: AppImages.email,
                  hint: appLocalization.email,
                ),
              ),
              SizedBox(height: 16.h),
              FadeInRight(
                child: CustomTextField(
                  controller: cubit.passwordTextController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  image: AppImages.password,
                  hint: appLocalization.password,
                ),
              ),
              SizedBox(height: 16.h),
              FadeInLeft(
                child: CustomTextField(
                  controller: cubit.phoneTextController,
                  keyboardType: TextInputType.phone,
                  image: AppImages.phone,
                  hint: appLocalization.phone,
                ),
              ),
              SizedBox(height: 16.h),
              FadeInRight(
                child: CustomTextField(
                  controller: cubit.ageTextController,
                  keyboardType: TextInputType.number,
                  image: AppImages.age,
                  hint: appLocalization.age,
                ),
              ),
              SizedBox(height: 16.h),
              FadeInLeft(
                child: CustomTextField(
                  controller: cubit.notesTextController,
                  keyboardType: TextInputType.multiline,
                  image: AppImages.notes,
                  hint: appLocalization.note,
                ),
              ),
              SizedBox(height: 32.h),
              FadeInRight(
                child: CustomButton(
                  onTap: cubit.signUp,
                  title: appLocalization.signUp,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              FadeInLeft(
                child: TextButton(
                  onPressed: () {
                    context.goNamed(LoginView.routeName);
                  },
                  child: text(appLocalization.already_have_an_account,
                      color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
