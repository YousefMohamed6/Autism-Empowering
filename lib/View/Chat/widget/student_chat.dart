import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../expanded_image.dart';

class StudentChat extends StatefulWidget {
  const StudentChat({
    super.key,
    required this.text,
    required this.underText,
    this.isMe = true,
    required this.readIcon,
    required this.map,
    required this.map2,
  });
  final String text;
  final String underText;
  final bool isMe;
  final String map;
  final String map2;
  final String readIcon;

  @override
  State<StudentChat> createState() => _StudentChatState();
}

class _StudentChatState extends State<StudentChat> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment:
              widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (widget.map == 'text')
              IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  constraints: BoxConstraints(maxWidth: 250.w, minWidth: 80.w),
                  alignment: widget.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: widget.isMe
                          ? AppColors.primaryColor
                          : Color(0xffF6F6F6),
                      borderRadius: widget.isMe
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8))
                          : const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: widget.isMe
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.text,
                        style: TextStyle(
                            color: widget.isMe
                                ? Colors.white
                                : AppColors.primaryColor,
                            fontSize: 14.sp,
                            fontFamily: 'tajwal'),
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.map == 'audio')
              VoiceMessageView(
                controller: VoiceController(
                  audioSrc: widget.text,
                  maxDuration: Duration(),
                  isFile: true,
                  onComplete: () {},
                  onPause: () {},
                  onPlaying: () {},
                ), // Do something when voice played.
              ),
            SizedBox(height: 10.h),
            if (widget.map == 'image')
              GestureDetector(
                onTap: () {
                  Get.to(() => ExpandedImage(
                        image: widget.map2,
                      ));
                },
                child: Container(
                  height: 170.h,
                  width: 170.w,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: widget.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: widget.isMe
                          ? AppColors.primaryColor
                          : Colors.grey.shade400,
                      borderRadius: widget.isMe
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8))
                          : const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8))),
                  child: Container(
                    height: 160.h,
                    width: 160.w,
                    alignment: widget.map2 != "" ? null : Alignment.center,
                    child: widget.map2 != ""
                        ? Image.network(
                            widget.map2,
                            fit: BoxFit.cover,
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            if (widget.map == 'file')
              widget.text.split('?').first.split('.').last == 'pdf'
                  ? GestureDetector(
                      onTap: () async {},
                      child: Container(
                        height: 78.h,
                        width: 295.w,
                        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        padding: EdgeInsets.only(right: 10.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 66.h,
                              width: 66.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.primaryColor,
                              ),
                              child: const Icon(Icons.file_copy,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.isMe
                                    ? Text(
                                        'مرفق',
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 13.sp,
                                            fontFamily: 'tajwal'),
                                      )
                                    : Text(
                                        'مرفق',
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 13.sp,
                                            fontFamily: 'tajwal'),
                                      ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'انقر لتحميل الملف',
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 12.sp,
                                      fontFamily: 'tajwal'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.to(() => ExpandedImage(
                              image: widget.map2,
                            ));
                      },
                      child: Container(
                        height: 170.h,
                        width: 170.w,
                        padding: const EdgeInsets.all(3),
                        alignment: widget.isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: widget.isMe
                                ? AppColors.primaryColor
                                : Colors.grey.shade400,
                            borderRadius: widget.isMe
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))
                                : const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                        child: Container(
                          height: 170.h,
                          width: 170.w,
                          alignment:
                              widget.map2 != "" ? null : Alignment.center,
                          child: widget.map2 != ""
                              ? Image.network(
                                  widget.map2,
                                  fit: BoxFit.cover,
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    ),
            Row(
              children: [
                widget.isMe
                    ? SvgPicture.asset(widget.readIcon)
                    : const SizedBox(),
                Container(
                    padding:
                        EdgeInsets.only(left: 10.h, bottom: 10.h, right: 10.w),
                    child: Text(
                      '${widget.underText} ',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'tajwal'),
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
