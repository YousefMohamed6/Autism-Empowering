import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class SendAudio extends GetxController {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  String userToken = FirebaseAuth.instance.currentUser!.uid;

  bool isPlaying = false;
  File? audioFile;
  UploadTask? uploadTask;

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future cancel() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    audioFile = File(path!);
  }

  Future stop({
    required String requesterName,
    required String reciverName,
    required String reciverID,
    required String serviceID,
    required String resepFcmToken,
  }) async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    audioFile = File(path!);
    uploadFile(
      requesterName: requesterName,
      reciverName: reciverName,
      serviceID: serviceID,
      reciverID: reciverID,
      resepFcmToken: resepFcmToken,
    );
  }

  Future uploadFile({
    required String serviceID,
    required String reciverID,
    required String requesterName,
    required String reciverName,
    required String resepFcmToken,
  }) async {
    final path = 'files/${audioFile!.path}';
    final file = File(audioFile!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    final firestore = FirebaseFirestore.instance;
    firestore.collection('Chat').doc(serviceID).collection('messages').add({
      'senderID': userToken,
      'reciverID': reciverID,
      'fcmToken': OneSignal.User.pushSubscription.id,
      'resepFcmToken': resepFcmToken,
      'senderName': requesterName,
      'reciverName': reciverName,
      'serviceID': serviceID,
      'time': DateTime.now(),
      'type': 'audio',
      'messageText': urlDownload,
      'isRead': false,
    });
    firestore.collection('Chat').doc(serviceID).set({
      'senderID': userToken,
      'reciverID': reciverID,
      'isEnd': true,
      'isDeleteFromRequester': false,
      'isDeleteFromReciver': false
    });
  }

  Future initRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permision Denied';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }
}
