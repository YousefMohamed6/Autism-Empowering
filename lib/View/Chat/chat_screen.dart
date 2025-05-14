import 'package:autism_empowering/View/Chat/Chat/send_file.dart';
import 'package:autism_empowering/View/Chat/Chat/send_image.dart';
import 'package:autism_empowering/View/Chat/Chat/send_message.dart';
import 'package:autism_empowering/core/utils/toast.dart';
import 'package:autism_empowering/View/Chat/widget/sendMessageBar.dart';
import 'package:autism_empowering/core/enums/toast_type.dart';
import 'package:autism_empowering/core/services/one_Signal_service.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'Chat/send_audio.dart';
import 'widget/appBar.dart';
import 'widget/show_record.dart';
import 'widget/student_chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.serviceID,
    required this.reciverID,
    required this.requesterName,
    required this.reciverName,
    required this.resepFcmToken,
  });
  final String serviceID;
  final String reciverID;
  final String requesterName;
  final String reciverName;
  final String resepFcmToken;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SendMessages sendMessage = Get.put(SendMessages());
  SendImage sendImage = Get.put(SendImage());
  SendFile sendFile = Get.put(SendFile());
  SendAudio sendAudio = Get.put(SendAudio());
  String id = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController controller = TextEditingController();
  bool isPlaying = false;
  String? fcmToken;

  @override
  void initState() {
    sendAudio.initRecording();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(
        requesterName: widget.reciverName,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('Chat')
                  .doc(widget.serviceID)
                  .collection('messages')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<StudentChat> messageWidgets = [];
                  final messages = snapshot.data!.docs.reversed;
                  for (var message in messages) {
                    final messageSender = message.get('senderID');
                    final messageText = message.get('messageText');
                    final messageType = message.get('type');
                    fcmToken = message.get('fcmToken');
                    final messageTime = message.get('time').toDate();
                    final messageWidget = StudentChat(
                      text: messageText,
                      map: messageType,
                      map2: messageText,
                      underText: DateFormat('HH:mm').format(messageTime),
                      isMe: id == messageSender,
                      readIcon: message.get('isRead') == false
                          ? AppImages.unread
                          : AppImages.read,
                    );

                    messageWidgets.add(messageWidget);

                    _firestore
                        .collection('Chat')
                        .doc(widget.serviceID)
                        .collection('messages')
                        .where('senderID', isNotEqualTo: id)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var documentSnapshot in querySnapshot.docs) {
                        final String messageId = documentSnapshot.id;
                        final DocumentReference messageRef = _firestore
                            .collection('Chat')
                            .doc(widget.serviceID)
                            .collection('messages')
                            .doc(messageId);
                        messageRef
                            .update({
                              "isRead": true,
                            })
                            .then((value) {})
                            .catchError((error) {});
                      }
                    });
                  }
                  return ListView(
                      reverse: true,
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      children: messageWidgets);
                } else if (snapshot.hasError) {
                  return const SpinKitCircle(
                      color: AppColors.primaryColor, size: 30);
                }
                return const SpinKitCircle(
                    color: AppColors.primaryColor, size: 30);
              },
            ),
          ),
          CustomSenderBar(
            messageController: controller,
            sendMessage: () async {
              if (controller.text.isNotEmpty) {
                sendMessage
                    .sendMessage(
                  serviceID: widget.serviceID,
                  reciverID: widget.reciverID,
                  senderName: widget.requesterName,
                  reciverName: widget.reciverName,
                  resepFcmToken: widget.resepFcmToken,
                  messageText: controller.text.trim(),
                )
                    .then((val) {
                  OneSignalService.sendNotification(
                    fcmToken: widget.resepFcmToken,
                    message: controller.text,
                    senderName: widget.requesterName,
                  ).then((value) {
                    controller.clear();
                  });
                });
              } else {}
            },
            sendImage: () {
              sendImage
                  .imgFromGallery(
                serviceID: widget.serviceID,
                reciverID: widget.reciverID,
                requesterName: widget.requesterName,
                reciverName: widget.reciverName,
                resepFcmToken: widget.resepFcmToken,
              )
                  .then((val) {
                OneSignalService.sendNotification(
                  fcmToken: widget.resepFcmToken,
                  message: 'Image',
                  senderName: widget.requesterName,
                ).then((value) {
                  controller.clear();
                });
              });
            },
            sendFile: () {
              sendFile.sendFile().then((value) {
                sendFile.uploadFile(
                  serviceID: widget.serviceID,
                  reciverID: widget.reciverID,
                  resepFcmToken: widget.resepFcmToken,
                  requesterName: widget.requesterName,
                  reciverName: widget.reciverName,
                );
              }).then((val) {
                OneSignalService.sendNotification(
                  fcmToken: widget.resepFcmToken,
                  message: 'File',
                  senderName: widget.requesterName,
                ).then((value) {
                  controller.clear();
                });
              });
            },
            sendAudio: () async {
              if (sendAudio.recorder.isRecording) {
                await sendAudio.cancel();

                Get.defaultDialog(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  title: '',
                  content: ShowRecord(
                    isPlaying: isPlaying,
                    sendAudioChat: () async {
                      if (!sendAudio.recorder.isRecording) {
                        await sendAudio
                            .stop(
                          requesterName: widget.requesterName,
                          reciverName: widget.reciverName,
                          serviceID: widget.serviceID,
                          reciverID: widget.reciverID,
                          resepFcmToken: widget.resepFcmToken,
                        )
                            .then((value) {
                          OneSignalService.sendNotification(
                            fcmToken: widget.resepFcmToken,
                            message: 'Voise Note',
                            senderName: widget.requesterName,
                          ).then((value) {
                            controller.clear();
                          });
                          Get.back();
                        });
                      } else {}
                      setState(() {});
                    },
                  ),
                );
              } else {
                displayToast(
                    title: '',
                    description: 'Speak Now ..',
                    status: ToastStatus.success);
                await sendAudio.record();
              }
              setState(() {});
            },
            micColor: sendAudio.recorder.isRecording
                ? Colors.red.shade300
                : AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}
