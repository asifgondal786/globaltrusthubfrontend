class SafetyConfig {
  static const bool panicButtonEnabled = true;
  static const bool autoChatFreeze = true; // On report

  static const List<String> reportCategories = [
    'scam',
    'harassment',
    'hate_speech',
    'identity_theft',
    'other',
  ];

  static const Map<String, dynamic> priorityEscalationRules = {
    'immediate_escalation': ['identity_theft', 'physical_threat'],
  };

  static const String moderatorResponseSla = '2h'; // Priority
  static const String evidenceRetentionPolicy = '3y';
}
