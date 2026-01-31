class ServicePostConfig {
  static const double monthlyPostFee = 9.99; // For non-subscribers
  static const int postDurationDays = 30;
  static const int maxActivePosts = 5; // Default limit

  static const Map<String, dynamic> contentRequirements = {
    'min_description_length': 100,
    'max_images': 5,
    'require_pricing': true,
  };

  static const int trustScoreMinimum = 600; // Minimum score to post
  static const String autoExpiryBehavior = 'archive'; // archive | delete
}
