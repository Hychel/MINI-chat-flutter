import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Логування екранів
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenClass: screenName,
      screenName: screenName,
    );
  }

  // Логування подій авторизації
  static Future<void> logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  static Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  // Логування чатів
  static Future<void> logCreateChat() async {
    await _analytics.logEvent(
      name: 'create_chat',
      parameters: {'method': 'manual_input'},
    );
  }

  static Future<void> logSendMessage() async {
    await _analytics.logEvent(
      name: 'send_message',
      parameters: {'length': 0},
    );
  }

  static Future<void> logDeleteChat() async {
    await _analytics.logEvent(
      name: 'delete_chat',
      parameters: {'method': 'long_press_or_menu'},
    );
  }

  // Логування профілю
  static Future<void> logSignOut() async {
    await _analytics.logEvent(name: 'sign_out');
  }

}
