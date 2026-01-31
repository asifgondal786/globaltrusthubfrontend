class ContentConfig {
  static const List<String> approvedNewsSources = [
    'bbc_education',
    'official_immigration_gov_feeds',
    'verified_universities',
  ];

  static const Map<String, List<String>> countrySpecificFeeds = {
    'US': ['usa_visa_updates', 'usa_scholarships'],
    'UK': ['uk_student_visa', 'uk_universities'],
  };

  static const String contentRefreshInterval = '1h';
  static const bool aiSummaryEnabled = true;

  static const Map<String, dynamic> contentModerationRules = {
    'block_hate_speech': true,
    'block_scam_keywords': true,
  };

  static const String politicalContentPolicy = 'block_strictly';
}
