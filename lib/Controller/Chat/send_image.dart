import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path/path.dart' as path;

class SendImage extends GetxController {
  String userToken = FirebaseAuth.instance.currentUser!.uid;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery(
      {required String serviceID,
      required String reciverID,
      required String requesterName,
      required String reciverName,
      required String resepFcmToken}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile(
        serviceID: serviceID,
        reciverID: reciverID,
        requesterName: requesterName,
        reciverName: reciverName,
        resepFcmToken: resepFcmToken,
      );
    } else {
      debugPrint('No image selected.');
    }
    update();
  }

  Future uploadFile({
    required String serviceID,
    required String requesterName,
    required String reciverName,
    required String reciverID,
    required String resepFcmToken,
  }) async {
    try {
      send(
        serviceID: serviceID,
        reciverID: reciverID,
        requesterName: requesterName,
        reciverName: reciverName,
        resepFcmToken: resepFcmToken,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future send(
      {required String serviceID,
      required String reciverID,
      required String requesterName,
      required String reciverName,
      required String resepFcmToken}) async {
    final fileName = path.basename(_photo!.path);
    final destination = '$userToken$fileName';
    final ref = FirebaseStorage.instance.ref(destination);
    final uploadTask = ref.putFile(_photo!);
    final taskSnapshot = await uploadTask;
    final fileURL = await taskSnapshot.ref.getDownloadURL();

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
      'type': 'image',
      'messageText': fileURL,
      'isRead': false,
    });
    firestore.collection('Chat').doc(serviceID).set({
      'senderID': userToken,
      'reciverID': reciverID,
      'isEnd': true,
      'isDeleteFromRequester': false,
      'isDeleteFromReciver': false
    });
    await ref.putFile(_photo!);
  }
}
