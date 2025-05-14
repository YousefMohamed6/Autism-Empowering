import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/services/api_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class OneSignalService {
  static String get _oneSignalAppId => 'f6d36d37-d26c-4973-8ead-e6600c5ba0cd';
  static String get _oneSignalApikey =>
      'OWNiOTgxMTQtZjY0Ny00NmY2LThkMDQtZjdiZjhiMjYzMzc0';
  static Future<void> initialize() async {
    await Permission.notification.request();
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(_oneSignalAppId);
    await OneSignal.Notifications.requestPermission(true);
    await AwesomeNotifications().initialize(
      '',
      [
        NotificationChannel(
          channelKey: 'routine_channel',
          channelName: 'Routine Channel',
          channelDescription: 'Channel for Routine Children Reminders',
          defaultColor: AppColors.primaryColor,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
        ),
      ],
    );
  }

  static Future<void> sendNotification({
    required String fcmToken,
    required String message,
    required String senderName,
  }) async {
    final ApiService apiService = ApiService();
    final Map<String, dynamic> notification = {
      'app_id': _oneSignalAppId,
      'include_player_ids': [fcmToken],
      'headings': {'en': senderName},
      'contents': {'en': message},
    };
    await apiService.post(
      url: 'https://onesignal.com/api/v1/notifications',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic $_oneSignalApikey',
      },
      body: notification,
    );
  }
}
