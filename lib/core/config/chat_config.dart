class ChatConfig {
  static const Map<String, List<String>> chatPermissionsMatrix = {
    // Role: [Can chat with]
    'student': ['university', 'agent', 'employer'],
    'guest': [],
  };

  static const Map<String, dynamic> messageRateLimits = {
    'messages_per_minute': 10,
    'messages_per_day_new_account': 50,
  };

  static const Map<String, bool> fileSharingRules = {
    'allow_images': true,
    'allow_pdf': true,
    'allow_archives': false, // No zip/rar
  };

  static const bool linkSharingPolicy = false; // Block links by default to prevent scams
  static const bool externalContactBlocking = true; // Block phone numbers/emails in chat text

  static const Map<String, dynamic> aiScamDetection = {
    'enabled': true,
    'warning_threshold': 0.85,
  };

  static const String chatRetentionPolicy = '365d'; // Retain chats for 1 year
}
