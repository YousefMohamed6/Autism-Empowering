import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../Chat/send_audio.dart';

class ShowRecord extends StatefulWidget {
  const ShowRecord(
      {super.key, required this.isPlaying, required this.sendAudioChat});
  final bool isPlaying;
  final VoidCallback sendAudioChat;
  @override
  State<ShowRecord> createState() => _ShowRecordState();
}

class _ShowRecordState extends State<ShowRecord> {
  SendAudio sendAudio = Get.put(SendAudio());
  @override
  Widget build(BuildContext context) {
    return sendAudio.audioFile == null
        ? const SizedBox()
        : !sendAudio.isRecorderReady
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VoiceMessageView(
                      controller: VoiceController(
                        audioSrc: sendAudio.audioFile!.path,
                        maxDuration: Duration(),
                        isFile: true,
                        onComplete: () {},
                        onPause: () {},
                        onPlaying: () {},
                      ), // Do something when voice played.
                    ),
                    TextButton(
                        onPressed: widget.sendAudioChat,
                        child:
                            text('Send', fontSize: 14.sp, color: Colors.white))
                  ],
                ),
              );
  }
}
