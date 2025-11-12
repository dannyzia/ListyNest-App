import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/storage_service.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final StorageService _storage;
  NotificationService(this._storage);

  Future<void> initialize() async {
    // Request permission for notifications
    await _requestPermission();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Get FCM token and save it
    await _setupFCMToken();

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> _setupFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        await _storage.saveFCMToken(token);
        await _sendTokenToServer(token);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM Token refreshed: $newToken');
        await _storage.saveFCMToken(newToken);
        await _sendTokenToServer(newToken);
      });
    } catch (e) {
      debugPrint('Error setting up FCM token: $e');
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Implement backend endpoint to save FCM token.
      // The ApiService is not stored by this class to keep the service
      // decoupled from network implementation; callers can send the token
      // to backend as needed using their ApiService instance.
      debugPrint('TODO: Send FCM token to backend: $token');
    } catch (e) {
      debugPrint('Error sending token to server: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.notification?.title}');

    // Show local notification
    _showLocalNotification(message);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('Message opened app: ${message.data}');

    // Handle navigation based on message data
    _handleNotificationNavigation(message.data);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      details,
      payload: message.data.toString(),
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');

    if (response.payload != null) {
      // Parse payload and navigate
      final data = _parsePayload(response.payload!);
      _handleNotificationNavigation(data);
    }
  }

  Map<String, dynamic> _parsePayload(String payload) {
    try {
      // Simple parsing - in production, use proper JSON parsing
      final Map<String, dynamic> data = {};
      final pairs = payload.replaceAll('{', '').replaceAll('}', '').split(', ');
      for (final pair in pairs) {
        final keyValue = pair.split(': ');
        if (keyValue.length == 2) {
          data[keyValue[0].replaceAll('"', '')] = keyValue[1].replaceAll('"', '');
        }
      }
      return data;
    } catch (e) {
      debugPrint('Error parsing notification payload: $e');
      return {};
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    // TODO: Implement navigation based on notification type
    // Examples:
    // - New message: navigate to chat screen
    // - New bid: navigate to auction details
    // - Ad approved: navigate to ad details

    final type = data['type'];
    final id = data['id'];

    debugPrint('Navigate to: type=$type, id=$id');

    // This will be implemented when we add navigation service
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

// Background message handler (must be top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
  // Handle background messages here
}