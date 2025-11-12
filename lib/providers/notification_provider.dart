import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService;

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _fcmToken;

  NotificationProvider(StorageService storage)
    : _notificationService = NotificationService(storage);

  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _notificationService.initialize();
      _fcmToken = await _notificationService.getFCMToken();
      _isInitialized = true;
      debugPrint('Notifications initialized successfully');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error initializing notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> subscribeToNewMessages() async {
    try {
      await _notificationService.subscribeToTopic('new_messages');
      debugPrint('Subscribed to new messages topic');
    } catch (e) {
      debugPrint('Error subscribing to new messages: $e');
    }
  }

  Future<void> subscribeToAdUpdates(String adId) async {
    try {
      await _notificationService.subscribeToTopic('ad_$adId');
      debugPrint('Subscribed to ad updates: $adId');
    } catch (e) {
      debugPrint('Error subscribing to ad updates: $e');
    }
  }

  Future<void> unsubscribeFromAdUpdates(String adId) async {
    try {
      await _notificationService.unsubscribeFromTopic('ad_$adId');
      debugPrint('Unsubscribed from ad updates: $adId');
    } catch (e) {
      debugPrint('Error unsubscribing from ad updates: $e');
    }
  }

  Future<void> subscribeToUserTopics(String userId) async {
    try {
      await _notificationService.subscribeToTopic('user_$userId');
      debugPrint('Subscribed to user topics: $userId');
    } catch (e) {
      debugPrint('Error subscribing to user topics: $e');
    }
  }

  // Method to send test notification (for development)
  Future<void> sendTestNotification() async {
    try {
      // TODO: Implement backend endpoint for sending test notifications
      debugPrint('TODO: Send test notification via backend');
    } catch (e) {
      debugPrint('Error sending test notification: $e');
    }
  }

  // Method to get notification history
  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      // TODO: Implement backend endpoint to get notification history
      // final response = await _apiService.get('/api/notifications/history');
      // return List<Map<String, dynamic>>.from(response['notifications']);
      debugPrint('TODO: Get notification history from backend');
      return [];
    } catch (e) {
      debugPrint('Error getting notification history: $e');
      return [];
    }
  }

  // Method to mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      // TODO: Implement backend endpoint to mark notification as read
      // await _apiService.put('/api/notifications/$notificationId/read');
      debugPrint('TODO: Mark notification as read: $notificationId');
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  // Method to clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      // TODO: Implement backend endpoint to clear notifications
      debugPrint('TODO: Clear all notifications');
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }
}