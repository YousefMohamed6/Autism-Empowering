import 'dart:async';
import 'package:autism_empowering/View/Auth/login.dart';
import 'package:autism_empowering/View/main_app.dart';
import 'package:autism_empowering/main.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  String? token = pref!.getString('userToken');

  getToNextPage() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (token != null) {
        Get.offAll(() => MainAppScreen(), transition: Transition.zoom);
        timer.cancel();
      } else {
        Get.offAll(() => LoginScreen(), transition: Transition.zoom);
        timer.cancel();
      }
    });
  }

  @override
  void onInit() {
    getToNextPage();
    super.onInit();
  }
}
