import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../Model/routine_model.dart';

class RoutineController extends GetxController {
  bool isLoading = true;
  final CollectionReference routineCollection =
      FirebaseFirestore.instance.collection('users');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new routine
  Future<void> addRoutine(String patientId, Routines routine) {
    return _firestore
        .collection('users')
        .doc(patientId)
        .collection('routines')
        .doc(routine.id)
        .set(routine.toMap());
  }

  // Update an existing routine
  Future<void> updateRoutine(String patientId, Routines routine) {
    return _firestore
        .collection('users')
        .doc(patientId)
        .collection('routines')
        .doc(routine.id)
        .update(routine.toMap());
  }

  // Delete a routine
  Future<void> deleteRoutine(String patientId, String routineId) {
    return _firestore
        .collection('users')
        .doc(patientId)
        .collection('routines')
        .doc(routineId)
        .delete();
  }

  // Stream of routines
  Stream<List<Routines>> getRoutines(String patientId) {
    return _firestore
        .collection('users')
        .doc(patientId)
        .collection('routines')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Routines.fromMap(doc.data(), doc.id))
            .toList());
  }

  // schedule notification
  void scheduleDailyNotification(Routines routine) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'routine_channel',
        title: '${routine.name} Routine Reminder',
        body: routine.notes,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: routine.startDate.hour,
        minute: routine.startDate.minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
