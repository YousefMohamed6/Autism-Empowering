import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/images.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/Controller/Const/toast.dart';
import 'package:autism_empowering/View/Auth/choose_type.dart';
import 'package:autism_empowering/View/main_app.dart';
import 'package:autism_empowering/main.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../Controller/Auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService authService = Get.put(AuthService());

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show an error message
      displaySuccessMotionToast(
          context: context,
          title: 'Warning',
          description: 'Please Fill All Data',
          status: 3);
      return;
    }
    try {
      User? user =
          await authService.signInWithEmailAndPassword(email, password);
      await user?.reload();
      if (user != null) {
        if (user.emailVerified) {
          pref!.setString('userToken', user.uid);
          Get.offAll(() => const MainAppScreen(), transition: Transition.zoom);
        } else {
          displaySuccessMotionToast(
              context: context,
              title: 'Login Failed',
              description: 'Unable to login. please verify your Accout ',
              status: 3);
        }
      } else {
        displaySuccessMotionToast(
            context: context,
            title: 'Login Failed',
            description: 'Unable to login. Check Email or Password',
            status: 3);
      }
    } catch (e) {
      displaySuccessMotionToast(
          context: context,
          title: 'Login Failed',
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
            progressIndicator:
                const SpinKitCircle(color: primaryColor, size: 30),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    FadeInUp(
                      child: Image.asset(
                        logo,
                        height: 200.h,
                        width: 200.w,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(child: text('Welcome', fontSize: 25.sp)),
                    SizedBox(height: 15.h),
                    FadeInLeft(
                      child: CustomTextField(
                        hint: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        image: account,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInRight(
                      child: CustomTextField(
                        hint: 'Password',
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        image: email,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeInLeft(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.w),
                        child: CustomButton(
                          title: 'Login',
                          onTap: _login,
                          color: primaryColor.withOpacity(0.8),
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInDown(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChooseTypeScreen()),
                          );
                        },
                        child: text('Don\'t have an account ? signup now',
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
