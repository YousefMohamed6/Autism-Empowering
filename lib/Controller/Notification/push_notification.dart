import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Const/texts.dart';

Future<void> sendNotification(
    String fcmToken, String message, String senderName) async {
  const String oneSignalRestApiKey = oneSignalApikey;

  final Map<String, dynamic> notification = {
    'app_id': oneSignalAppId,
    'include_player_ids': [fcmToken],
    'headings': {'en': senderName},
    'contents': {'en': message},
  };

  final response = await http.post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Basic $oneSignalRestApiKey',
    },
    body: jsonEncode(notification),
  );

  if (response.statusCode == 200) {
    debugPrint('Notification sent successfully.');
    log(response.body.toString());
  } else {
    debugPrint('Failed to send notification: ${response.body}');
  }
}
