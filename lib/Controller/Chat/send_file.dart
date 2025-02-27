import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SendFile extends GetxController {
  String userToken = FirebaseAuth.instance.currentUser!.uid;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future sendFile() async {
    final result = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);
    if (result == null) return;
    pickedFile = result.files.first;
    update();
  }

  Future uploadFile({
    required String serviceID,
    required String reciverID,
    required String requesterName,
    required String reciverName,
    required String resepFcmToken,
  }) async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    final firestore = FirebaseFirestore.instance;
    firestore.collection('Chat').doc(serviceID).collection('messages').add({
      'senderID': userToken,
      'fcmToken': OneSignal.User.pushSubscription.id,
      'resepFcmToken': resepFcmToken,
      'senderName': requesterName,
      'reciverName': reciverName,
      'serviceID': serviceID,
      'reciverID': reciverID,
      'time': DateTime.now(),
      'type': 'file',
      'messageText': urlDownload,
      'isRead': false,
    });
    firestore.collection('Chat').doc(serviceID).set({'senderID': userToken, 'reciverID': reciverID, 'isEnd': true, 'isDeleteFromRequester': false, 'isDeleteFromReciver': false});
  }
}
