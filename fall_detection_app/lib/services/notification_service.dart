import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static int badgeCount = 0;

  // Local notification plugin
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Firebase Messaging instance
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  // Initialize notification service
  Future<void> initialize() async {
    debugPrint('NotificationService: Initializing...');

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Initialize Firebase Cloud Messaging
    await _initializeFirebaseMessaging();

    // Request notification permission
    await _requestNotificationPermission();

    debugPrint('NotificationService: Initialized successfully');
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'fall_detection_channel',
      'Fall Detection Notifications',
      description: 'Important notifications for fall detection',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Request permission specifically for Android local notifications
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    debugPrint('NotificationService: Local notifications initialized');
  }

  // Initialize Firebase Cloud Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('NotificationService: Received foreground message');
      debugPrint('Message data: ${message.data}');
      debugPrint('Message notification: ${message.notification}');

      _handleMessage(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle message when app is terminated and opened from notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('NotificationService: App opened from notification');
        _handleMessage(message);
      }
    });

    debugPrint('NotificationService: Firebase messaging initialized');
  }

  // Request notification permission
  Future<void> _requestNotificationPermission() async {
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    debugPrint('NotificationService: Permission status: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await messaging.getToken();
    debugPrint('NotificationService: FCM Token: $token');
  }

  // Handle incoming messages
  void _handleMessage(RemoteMessage message) {
    final status = message.data['status'] ?? '';

    // Show local notification
    _showLocalNotification(
      title: message.notification?.title ?? 'Fall Detection',
      body: message.notification?.body ?? 'Status: $status',
      payload: status,
    );

    // Increment badge if fall detected
    if (status.toLowerCase().contains('jatuh') || status.toLowerCase().contains('fall')) {
      badgeCount++;
      debugPrint('NotificationService: Badge incremented to $badgeCount');
    }
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'fall_detection_channel',
      'Fall Detection Notifications',
      channelDescription: 'Important notifications for fall detection',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Fall Detection Alert',
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    debugPrint('NotificationService: Local notification shown - $title: $body');
  }

  // Callback when notification is tapped
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    debugPrint('Notification tapped: ${notificationResponse.payload}');
    // Handle navigation or other actions when notification is tapped
  }

  // Note: _updateBadge method removed as setUnreadCount is not available in flutter_local_notifications

  // Public method to show notification from anywhere
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('NotificationService.showNotification called - Title: $title, Body: $body');
    await _showLocalNotification(
      title: title,
      body: body,
      payload: payload ?? '',
    );
  }

  // Clear badge
  Future<void> clearBadge() async {
    badgeCount = 0;
    debugPrint('NotificationService: Badge cleared');
  }

  // Get current badge count
  static int getBadgeCount() {
    return badgeCount;
  }
}

// Background message handler (must be top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
  debugPrint('Background message data: ${message.data}');

  // Show notification even when app is in background
  await NotificationService()._showLocalNotification(
    title: message.notification?.title ?? 'Fall Detection',
    body: message.notification?.body ?? 'Status update received',
    payload: message.data['status'] ?? '',
  );
}
