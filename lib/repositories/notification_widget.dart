// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationWidget {
//   static final _notification = FlutterLocalNotificationsPlugin();
//   static Future init({bool scheduled = false}) async {
//     var initAndroidSettings = AndroidInitializationSettings(
//       'mipmap/ic_launcher',
//     );
//     var ios = DarwinInitializationSettings();
//     final settings =
//         InitializationSettings(android: initAndroidSettings, iOS: ios);
//     await _notification.initialize(settings);
//   }

//   static Future showNotification() async {
//     _notification.show(0, 'title', 'body', await notificationDetails());
//   }

//   static notificationDetails() async {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails(
//             // '32f44996-9f06-49e9-b473-abf46a718943', 'efef',
//             '32f44996-9f06-49e9-b473-abf46a718943',
//             'toca_sirene',
//             importance: Importance.max,
//             playSound: true,
//             sound: RawResourceAndroidNotificationSound('sirene')),
//         iOS: DarwinNotificationDetails(sound: 'sirene'));
//   }
// }
