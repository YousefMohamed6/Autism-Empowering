import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SendMessages extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  String userToken = FirebaseAuth.instance.currentUser!.uid;

  sendMessage({
    required String senderName,
    required String reciverName,
    required String messageText,
    required String serviceID,
    required String reciverID,
    required String resepFcmToken,
  }) async {
    _firestore.collection('Chat').doc(serviceID).collection('messages').add({
      'senderID': userToken,
      'senderName': senderName,
      'reciverName': reciverName,
      'serviceID': serviceID,
      'reciverID': reciverID,
      'time': DateTime.now(),
      'type': 'text',
      'messageText': messageText,
      'fcmToken': OneSignal.User.pushSubscription.id,
      'resepFcmToken': resepFcmToken,
      'isRead': false,
    });
    _firestore.collection('Chat').doc(serviceID).set({'senderID': userToken, 'reciverID': reciverID, 'isEnd': true, 'isDeleteFromRequester': false, 'isDeleteFromReciver': false});
  }
}
