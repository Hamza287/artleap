import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  // Private constructor
  AnalyticsService._privateConstructor();
  // Singleton instance
  static final AnalyticsService _instance =
      AnalyticsService._privateConstructor();
  // Public getter for the instance
  static AnalyticsService get instance => _instance;
  // Firebase Analytics instance
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  // Public getter for the FirebaseAnalytics instance (optional)
  FirebaseAnalytics get analytics => _analytics;
  // Log screen view
  Future<void> logScreenView({required String screenName}) async {
    await _analytics.logEvent(
      name: 'screen_view',
      parameters: {'screen_name': screenName},
    );
    print('Logged screen view: $screenName');
  }

  // Log button click
  Future<void> logButtonClick({required String buttonName}) async {
    await _analytics.logEvent(
      name: 'button_click',
      parameters: {'button_name': buttonName},
    );
    print('Logged button click: $buttonName');
  }
}
