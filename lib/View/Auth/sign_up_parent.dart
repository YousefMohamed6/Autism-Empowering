import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/Controller/Auth/auth_service.dart';
import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/images.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/Controller/Const/toast.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'login.dart';

class SignUpParentScreen extends StatefulWidget {
  const SignUpParentScreen({super.key});

  @override
  _SignUpParentScreenState createState() => _SignUpParentScreenState();
}

class _SignUpParentScreenState extends State<SignUpParentScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String role = 'Parent';

  AuthService authService = Get.put(AuthService());

  Future<void> _signUp() async {
    try {
      User? user = await authService.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
        _ageController.text.trim(),
        _notesController.text.trim(),
        role,
        _phoneController.text.trim(),
      );
      if (user != null) {
        await user.sendEmailVerification();
        Get.offAll(() => LoginScreen(), transition: Transition.zoom);
      } else {
        // Show error message
        displaySuccessMotionToast(
            context: context,
            title: 'Faild To make New Account',
            description: 'Faild To make New Account, Please try again',
            status: 3);
      }
    } catch (e) {
      // Show error message
      displaySuccessMotionToast(
          context: context,
          title: 'Faild To make New Account',
          description: e.toString(),
          status: 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AuthService(),
        builder: (controller) {
          return BlurryModalProgressHUD(
            inAsyncCall: controller.isLoading,
            progressIndicator: const SpinKitCircle(
              color: primaryColor,
              size: 30,
            ),
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                surfaceTintColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: [
                    FadeInRight(
                      child: Image.asset(
                        logo,
                        height: 200.h,
                        width: 200.w,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInLeft(
                        child: Center(
                            child: text('Sign Up As Doctor', fontSize: 25.sp))),
                    SizedBox(height: 20.h),
                    FadeInRight(
                      child: CustomTextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        image: account,
                        hint: 'Name',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInLeft(
                      child: CustomTextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        image: email,
                        hint: 'Email',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInRight(
                      child: CustomTextField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        image: password,
                        hint: 'Password',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInLeft(
                      child: CustomTextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        image: phone,
                        hint: 'Phone Number',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInRight(
                      child: CustomTextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        image: age,
                        hint: 'Age',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FadeInLeft(
                      child: CustomTextField(
                        controller: _notesController,
                        keyboardType: TextInputType.multiline,
                        image: notes,
                        hint: 'Notes',
                      ),
                    ),
                    SizedBox(height: 32.h),
                    FadeInRight(
                      child: CustomButton(
                        onTap: () {
                          if (_ageController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _nameController.text.isNotEmpty &&
                              _notesController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _phoneController.text.isNotEmpty) {
                            _signUp();
                          } else {
                            displaySuccessMotionToast(
                                context: context,
                                title: 'Warning',
                                description: 'Complete All Data',
                                status: 3);
                          }
                        },
                        title: 'Sign Up',
                        textColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInLeft(
                      child: TextButton(
                        onPressed: () {
                          Get.offAll(() => LoginScreen(),
                              transition: Transition.zoom);
                        },
                        child: text('Already have account ? login ',
                            color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
