class AppConfig {
  static const String appName = 'GlobalTrustHub';
  static const String environment = 'development'; // development | staging | production
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'ur', 'ar'];
  static const String defaultCountry = 'US';
  static const String timezone = 'UTC';
  static const bool maintenanceMode = false;

  static const Map<String, bool> featureFlags = {
    'chat_enabled': true,
    'ai_warnings_enabled': true,
    'paid_posts_enabled': false,
    'mentor_program_enabled': true,
  };
}
