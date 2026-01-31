class VerificationConfig {
  static const Map<String, List<String>> requiredDocumentsByRole = {
    'student': ['student_id', 'passport'],
    'agent': ['business_license', 'id_proof', 'tax_document'],
  };

  static const Map<String, dynamic> verificationLevels = {
    'level_1_identity': 'Basic identity verification',
    'level_2_address': 'Address verification',
    'level_3_legitimacy': 'Business/Academic legitimacy check',
  };

  static const Map<String, dynamic> documentValidationRules = {
    'image_quality_threshold': 0.8, // 0.0 to 1.0
    'expiry_check': true,
  };

  static const double manualReviewThreshold = 0.7; // Confidence score below which human review is needed
  static const List<String> autoRejectionRules = ['blurred_image', 'expired_document'];
  static const int reverificationCycleDays = 365;
}
