import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// void scheduleAlarm(DateTime date) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'alarm_notif',
//     'alarm_notif',
//     icon: 'app_icon',
//     playSound: true,
//     priority: Priority.max,
//     visibility: NotificationVisibility.public,
//     importance: Importance.max,
//     sound: RawResourceAndroidNotificationSound('jonas'),
//     largeIcon: DrawableResourceAndroidBitmap('app_icon'),
//     color: const Color.fromARGB(255, 255, 0, 0),
//     styleInformation: BigTextStyleInformation(''),
//   );
//
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails(
//       sound: 'a_long_cold_sting.wav',
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true);
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);
//
//   var now = DateTime.now().add(Duration(seconds: 3));
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Office',
//       'alarmInfo.title',
//       TZDateTime.from(date, tz.local),
//       platformChannelSpecifics,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time);
// }

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  static Future init({bool initSchedled = false}) async {
    final android = AndroidInitializationSettings('app_icon');
    final ios = IOSInitializationSettings();
    final setting = InitializationSettings(iOS: ios, android: android);
    await _notification.initialize(setting,
        onSelectNotification: (payload) async {
      onNotifications.add('payload');
    });

    if (initSchedled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required DateTime dateTime}) async =>
      _notification.zonedSchedule(
          id,
          title,
          body,
          _scheduleWeekly(Time(dateTime.hour, dateTime.minute),
              days: [DateTime.friday, DateTime.saturday]),
          NotificationDetails(
              android: AndroidNotificationDetails(
                'alarm_notif',
                'alarm_notif',
                icon: 'app_icon',
                playSound: true,
                priority: Priority.max,
                importance: Importance.max,
                sound: RawResourceAndroidNotificationSound('jonas'),
                largeIcon: DrawableResourceAndroidBitmap('app_icon'),
                color: const Color.fromARGB(255, 255, 0, 0),
                styleInformation: BigTextStyleInformation(''),
              ),
              iOS: IOSNotificationDetails(
                  sound: 'a_long_cold_sting.wav',
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true)),
          payload: payload,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dateAndTime);

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(time);

    while (!days.contains(scheduledDate.weekday)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }
}
