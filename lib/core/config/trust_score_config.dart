class TrustScoreConfig {
  static const int baseScore = 500;

  static const Map<String, int> scoreComponents = {
    'verification_weight': 200,
    'reviews_weight': 150,
    'success_outcomes_weight': 150,
    'complaint_penalty': -50,
  };

  static const Map<String, int> decayRules = {
    'inactivity_penalty_per_month': -10,
  };

  static const Map<String, int> boostRules = {
    'long_term_success_bonus': 50, // Per year of good standing
  };

  static const Map<String, int> visibilityThresholds = {
    'featured_provider_min_score': 800,
    'trusted_badge_min_score': 700,
  };

  static const int autoSuspensionScore = 300;
}
