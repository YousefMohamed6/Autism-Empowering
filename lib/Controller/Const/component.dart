import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.controller,
      required this.image,
      this.onSaved,
      this.initialValue,
      required this.keyboardType,
      this.hint = '',
      this.obscureText = false});
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String image;
  final bool obscureText;
  final String hint;
  final String? initialValue;
  final void Function(String?)? onSaved;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 35.h,
          width: 35.w,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor,
          ),
          child: SvgPicture.asset(
            image,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: TextFormField(
              initialValue: initialValue,
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onSaved: onSaved,
              style: TextStyle(
                fontFamily: 'tajwal',
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.start,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    fontFamily: 'tajwal', fontSize: 16.sp, color: Colors.grey),
                fillColor: primaryColor.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.color = primaryColor,
      this.fontSize = 16,
      this.borderRadius = 25,
      this.height = 45,
      this.textColor = Colors.black,
      required this.title,
      required this.onTap,
      this.width});
  final double height;
  final Color color;
  final String title;
  final Color textColor;
  final VoidCallback onTap;
  final double borderRadius;
  final double fontSize;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          color: color,
        ),
        child: text(title, color: textColor, fontSize: fontSize),
      ),
    );
  }
}

class BackButtons extends StatelessWidget {
  const BackButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }
}

class CustomDrawerItem extends StatelessWidget {
  const CustomDrawerItem(
      {super.key, required this.title, required this.onPressed});
  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          height: 40.h,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: primaryColor.withOpacity(0.3),
          ),
          child: text(title, color: primaryColor)),
    );
  }
}
