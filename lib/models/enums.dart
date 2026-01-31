/// User roles in GlobalTrustHub
enum UserRole {
  student,
  agent,
  institution,
  provider,
}

/// User verification status
enum VerificationStatus {
  pending,
  verified,
  rejected,
  expired,
}

/// Document types for verification
enum DocumentType {
  cnic,
  passport,
  drivingLicense,
  domicile,
  businessLicense,
  address,
  criminalRecord,
}

/// Journey milestone status
enum MilestoneStatus {
  notStarted,
  inProgress,
  completed,
  skipped,
}

/// Trust score level
enum TrustLevel {
  low,
  medium,
  high,
  excellent,
}

/// Subscription status
enum SubscriptionStatus {
  free,
  active,
  expired,
  cancelled,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student / Job Seeker';
      case UserRole.agent:
        return 'Agent';
      case UserRole.institution:
        return 'Institution / Bank';
      case UserRole.provider:
        return 'Service Provider';
    }
  }

  String get description {
    switch (this) {
      case UserRole.student:
        return 'Apply for admissions, jobs, housing and access financial tools';
      case UserRole.agent:
        return 'Offer visa, IELTS, and travel services to verified students';
      case UserRole.institution:
        return 'Universities, banks and money transfer services';
      case UserRole.provider:
        return 'Employers, landlords, hostels and hotels';
    }
  }

  bool get requiresSubscription {
    return this != UserRole.student;
  }

  double get monthlyFee {
    switch (this) {
      case UserRole.student:
        return 0;
      case UserRole.agent:
      case UserRole.institution:
      case UserRole.provider:
        return 10.0;
    }
  }
}

extension TrustLevelExtension on TrustLevel {
  String get displayName {
    switch (this) {
      case TrustLevel.low:
        return 'Building Trust';
      case TrustLevel.medium:
        return 'Trusted';
      case TrustLevel.high:
        return 'Highly Trusted';
      case TrustLevel.excellent:
        return 'Excellent';
    }
  }

  static TrustLevel fromScore(double score) {
    if (score >= 80) return TrustLevel.excellent;
    if (score >= 60) return TrustLevel.high;
    if (score >= 30) return TrustLevel.medium;
    return TrustLevel.low;
  }
}
