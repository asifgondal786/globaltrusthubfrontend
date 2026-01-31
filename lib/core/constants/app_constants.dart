// GlobalTrustHub - App Constants
class AppConstants {
  // App Info
  static const String appName = 'GlobalTrustHub';
  static const String appTagline = 'Trusted Pathways for Global Education, Work & Settlement';
  static const String appVersion = '1.0.0';

  // User Roles
  static const String roleStudent = 'student';
  static const String roleAgent = 'agent';
  static const String roleInstitution = 'institution';
  static const String roleProvider = 'provider';

  // Verification Levels
  static const int verificationNone = 0;
  static const int verificationBasic = 1;      // Email/Phone verified
  static const int verificationIdentity = 2;   // CNIC/Passport verified
  static const int verificationAddress = 3;    // Address verified
  static const int verificationComplete = 4;   // All documents verified

  // Trust Score Thresholds
  static const double trustScoreLow = 30.0;
  static const double trustScoreMedium = 60.0;
  static const double trustScoreHigh = 80.0;

  // Subscription Pricing
  static const double agentMonthlyFee = 10.0;
  static const double institutionMonthlyFee = 10.0;
  static const double providerMonthlyFee = 10.0;
  static const double promotionMonthlyFee = 20.0;

  // API Endpoints (placeholder for backend integration)
  static const String apiBaseUrl = 'https://api.globaltrusthub.com/v1';

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserRole = 'user_role';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingComplete = 'onboarding_complete';
}
