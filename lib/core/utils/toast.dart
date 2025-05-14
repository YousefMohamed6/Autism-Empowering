import 'package:autism_empowering/core/enums/toast_type.dart';
import 'package:autism_empowering/core/services/router_manager.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

void displayToast({
  required String title,
  required String description,
  required ToastStatus status,
}) {
  late MotionToast toast;
  switch (status) {
    case ToastStatus.error:
      toast = MotionToast.error(
        title: text(title),
        description: text(description),
        dismissable: true,
        displaySideBar: false,
      );
      break;
    case ToastStatus.success:
      toast = MotionToast.success(
        title: text(title),
        description: text(description),
        dismissable: true,
        displaySideBar: false,
      );
      break;
    case ToastStatus.warning:
      toast = MotionToast.warning(
        title: text(title),
        description: text(description),
        dismissable: true,
        displaySideBar: false,
      );
      break;
  }
  final BuildContext context = RouterManager.navigatorKey.currentContext!;
  toast.show(context);
}
