

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  late BuildContext _context;

  Future<FlutterLocalNotificationsPlugin> initNotifies(
      BuildContext context) async {
    this._context = context;
    //-----------------------------| Initialize local notifications |--------------------------------------
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        onSelectNotification(notificationResponse.payload);
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medicines_id',
      'Medicines Notifications',
      description: 'This channel is used for medicines notifications',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    return flutterLocalNotificationsPlugin;
    //======================================================================================================
  }

  //---------------------------------| Show the notification in the specific time |-------------------------------
  Future showNotification(String title, String description, int time, int id,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id.toInt(),
        title,
        description,
        tz.TZDateTime.now(tz.local).add(Duration(milliseconds: time)),
        const NotificationDetails(
            android: AndroidNotificationDetails('medicines_id', 'medicines',
                channelDescription: 'medicines_notification_channel',
                importance: Importance.high,
                priority: Priority.high,
                color: Colors.cyanAccent)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  //================================================================================================================

  //-------------------------| Cancel the notify |---------------------------
  Future removeNotify(int notifyId,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    try {
      return await flutterLocalNotificationsPlugin.cancel(notifyId);
    } catch (e) {
      return null;
    }
  }

  //==========================================================================

  //-------------| function to initialize local notifications |---------------------------
  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      showDialog(
        context: _context,
        builder: (_) {
          return AlertDialog(
            title: Text("PayLoad"),
            content: Text("Payload : $payload"),
          );
        },
      );
    }
  }
//======================================================================================
}