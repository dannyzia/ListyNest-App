import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logScreenView(String? screenName) async {
    await _analytics.logEvent(
      name: 'screen_view',
      parameters: {'firebase_screen': screenName},
    );
  }

  Future<void> logFavorite(String adId, bool isFavorite) async {
    await _analytics.logEvent(
      name: 'favorite',
      parameters: {
        'ad_id': adId,
        'is_favorite': isFavorite.toString(),
      },
    );
  }

  Future<void> setUserFavoriteCount(int count) async {
    await _analytics.setUserProperty(
      name: 'favorite_count',
      value: count.toString(),
    );
  }
}
