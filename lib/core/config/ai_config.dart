class AiConfig {
  static const Map<String, bool> modelActivationFlags = {
    'fraud_detection': true,
    'content_moderation': true,
    'scam_language_analysis': true,
    'trust_score_prediction': true,
  };

  static const Map<String, double> confidenceThresholds = {
    'fraud_alert': 0.85,
    'content_flag': 0.70,
  };

  static const bool humanReviewFallback = true;
  static const String biasAuditSchedule = 'quarterly';
  static const bool explainabilityRequired = true; // AI must explain why score changed
  static const bool userOverrideAllowed = true; // In specific non-critical cases
}
