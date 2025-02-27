import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

void displaySuccessMotionToast({required BuildContext context, required String title, required String description, required int status}) {
  MotionToast? toast;
  if (status == 1) {
    toast = MotionToast.error(
      title: text(title),
      description: text(description),
      dismissable: true,
      displaySideBar: false,
    );
  } else if (status == 2) {
    toast = MotionToast.success(
      title: text(title),
      description: text(description),
      dismissable: true,
      displaySideBar: false,
    );
  } else if (status == 3) {
    toast = MotionToast.warning(
      title: text(title),
      description: text(description),
      dismissable: true,
      displaySideBar: false,
    );
  }
  toast!.show(context);
}
