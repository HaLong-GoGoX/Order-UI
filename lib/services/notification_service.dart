// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService.instance.setupFlutterNotifications();
//   await NotificationService.instance.showNotification(message);
// }

// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();

//   final _messaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//   bool _isFlutterLocalNotificationsInitialized = false;

//   Future<void> initialize() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // request permission
//     await _requestPermission();

//     // setup message handlers
//     await _setupMessageHandlers();

//     // get FCM token
//     final token = await _messaging.getToken();
//     debugPrint('FCM Token: $token');
//   }

//   Future<void> _requestPermission() async {
//     final settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//       announcement: false, 
//       carPlay: false,
//       criticalAlert: false,
//     );
    
//     debugPrint('Permission status: ${settings.authorizationStatus}');
//   }

//   Future<void> setupFlutterNotifications() async {
//     if (_isFlutterLocalNotificationsInitialized) return;

//     // android setup
//     const channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//     );

//     await _localNotifications
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//     const initializationSettingsAndroid = 
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // iOS setup
//     final initializationSettingsDarwin = DarwinInitializationSettings(
//       notificationCategories: <DarwinNotificationCategory>[],
//     );

//     final initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       const channelId = 'high_importance_channel';
//       const channelName = 'High Importance Notifications';

//       final details = NotificationDetails(
//         android: AndroidNotificationDetails(
//           channelId,
//           channelName,
//           channelDescription: 'This channel is used for important notifications.',
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//         ),
//         iOS: const DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       );

//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         details,
//         payload: message.data.toString(),
//       );
//     }
//   }

//   Future<void> _setupMessageHandlers() async {
//     // Foreground message
//     FirebaseMessaging.onMessage.listen((message) {
//       showNotification(message);
//     });

//     // background message
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

//     // opened app
//     final initialMessage = await _messaging.getInitialMessage();
//     if(initialMessage != null) {
//       _handleBackgroundMessage(initialMessage);
//     }
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {
//     if (message.data['type'] == 'chat') {
//       // open chat screen
//     }
//   }
// }