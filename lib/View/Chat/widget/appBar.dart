import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBarName extends StatelessWidget {
  const CustomAppBarName({super.key, required this.texts});
  final String texts;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165.h,
      width: double.infinity,
      padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 50.h),
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
        gradient: LinearGradient(
          colors: [],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: text(texts, color: Colors.white),
    );
  }
}

PreferredSizeWidget customAppBar(
    {required String requesterName, widgetBuilder}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    title: text(
      requesterName,
      fontSize: 16.sp,
      color: AppColors.primaryColor,
    ),
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(
        Icons.arrow_back_ios,
        color: AppColors.primaryColor,
        size: 30,
      ),
    ),
  );
}
