import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomSenderBar extends StatelessWidget {
  const CustomSenderBar({
    super.key,
    required this.messageController,
    required this.sendImage,
    required this.sendMessage,
    required this.sendFile,
    required this.sendAudio,
    required this.micColor,
  });
  final TextEditingController messageController;
  final VoidCallback sendMessage;
  final VoidCallback sendImage;
  final VoidCallback sendFile;
  final VoidCallback sendAudio;
  final Color micColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: double.infinity,
      margin: EdgeInsets.only(left: 17.w, right: 17.w, bottom: 5.h),
      child: SafeArea(
        bottom: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: sendImage,
              child: Container(
                height: 44.h,
                width: 44.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.camera_enhance_outlined,
                  color: primaryColor,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  maxLines: null,
                  controller: messageController,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                      fontFamily: 'tajwal',
                      fontSize: 14.sp,
                      color: primaryColor),
                  decoration: InputDecoration(
                    hintText: 'أكتب رسالتك هنا',
                    hintStyle: TextStyle(
                        fontFamily: 'tajwal',
                        fontSize: 14.sp,
                        color: Colors.grey.shade300),
                    suffixIcon: GestureDetector(
                      onTap: sendFile,
                      child: SvgPicture.asset(
                        attach,
                        fit: BoxFit.scaleDown,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    prefixIcon: GestureDetector(
                      onTap: sendAudio,
                      child: SvgPicture.asset(
                        mic,
                        fit: BoxFit.scaleDown,
                        color: micColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: sendMessage,
              child: Container(
                height: 44.h,
                width: 44.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: primaryColor,
                ),
                child: SvgPicture.asset(
                  send,
                  color: Colors.white,
                  fit: BoxFit.scaleDown,
                  height: 30.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
