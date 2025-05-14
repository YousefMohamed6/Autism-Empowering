import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatMethod extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  String userToken = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> getMessageRoom() {
    final Query messagesQuery = _firestore
        .collection('Chat')
        .where(Filter.or(Filter('senderID', isEqualTo: userToken),
            Filter('reciverID', isEqualTo: userToken)))
        .where('isDeleteFromRequester', isEqualTo: false);
    Stream<QuerySnapshot> messagesStream = messagesQuery.snapshots();
    return messagesStream;
  }

  Stream<QuerySnapshot> getMessages({required String docID}) {
    final Query messagesQuery = _firestore
        .collection('Chat')
        .doc(docID)
        .collection('messages')
        .where(Filter.or(Filter('senderID', isEqualTo: userToken),
            Filter('reciverID', isEqualTo: userToken)));
    Stream<QuerySnapshot> messagesStream = messagesQuery.snapshots();
    return messagesStream;
  }

  Future<DocumentSnapshot> getLastMessage({required String docID}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Chat')
        .doc(docID)
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(1)
        .get();
    return querySnapshot.docs.first;
  }

  Future deleteChatRoom({required String serviceID}) async {
    final chatRoomRef =
        FirebaseFirestore.instance.collection("Chat").doc(serviceID);
    return chatRoomRef.update(({'isDeleteFromRequester': true}));
  }
}
