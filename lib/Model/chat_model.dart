import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final String doctorId;
  final String patientId;
  final String lastMessage;
  final Timestamp timestamp;
  final String patientName;
  final String doctorName;

  Chat({
    required this.chatId,
    required this.doctorId,
    required this.patientId,
    required this.lastMessage,
    required this.timestamp,
    required this.patientName,
    required this.doctorName,
  });

  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
      chatId: doc['chatId'],
      doctorId: doc['doctorId'],
      patientId: doc['patientId'],
      lastMessage: doc['lastMessage'],
      timestamp: doc['timestamp'],
      patientName: doc['patientName'],
      doctorName: doc['doctorName'],
    );
  }
}
