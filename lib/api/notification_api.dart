import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';

class LocalNotificationService {
  LocalNotificationService();
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> intialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_stat_new_project_1');
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: _onDidRecieveLocalNotification);

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(settings,
        onSelectNotification: onSelectNotification);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showPeriodicNotification({
    required int id,
    required String title,
    required String body,
    required int values,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.periodicallyShow(
        id, title, body, RepeatInterval.hourly, details);
  }

  Future<void> showRandomNotification({
    required int id,
    required String title,
    required List bodies,
    required double heartPriority
  }) async {
    List tempBodies = [];
    if (Random().nextInt(100) > heartPriority*10) {
      for (int i = 0; i < bodies.length; i++) {
        if (bodies[i]["hearted"] == 'true') {
          tempBodies.add(bodies[i]);
          print(bodies[i]);
        }
      }
      bodies = tempBodies;
      tempBodies = [];
      print('hearted message: ' + bodies[0].toString());
    }
    final body = bodies[Random().nextInt(bodies.length)]["message"];
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      required int seconds}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Future<void> showNotificationWithPayload({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   final details = await _notificationDetails();
  //   await _localNotificationService.show(id, title, body, details, payload: payload);
  // }

  void _onDidRecieveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onSelectNotification(String? payload) {
    print(payload);
  }
}
