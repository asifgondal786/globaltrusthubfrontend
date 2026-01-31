import 'package:global_trust_hub/models/enums.dart';

/// Verification document model
class VerificationDocument {
  final String id;
  final String userId;
  final DocumentType type;
  final String? documentNumber;
  final VerificationStatus status;
  final double? aiConfidenceScore;
  final String? rejectionReason;
  final DateTime uploadedAt;
  final DateTime? verifiedAt;

  const VerificationDocument({
    required this.id,
    required this.userId,
    required this.type,
    this.documentNumber,
    required this.status,
    this.aiConfidenceScore,
    this.rejectionReason,
    required this.uploadedAt,
    this.verifiedAt,
  });

  bool get isVerified => status == VerificationStatus.verified;

  factory VerificationDocument.fromJson(Map<String, dynamic> json) {
    return VerificationDocument(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: DocumentType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => DocumentType.cnic,
      ),
      documentNumber: json['document_number'] as String?,
      status: VerificationStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => VerificationStatus.pending,
      ),
      aiConfidenceScore: (json['ai_confidence_score'] as num?)?.toDouble(),
      rejectionReason: json['rejection_reason'] as String?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'document_number': documentNumber,
      'status': status.name,
      'ai_confidence_score': aiConfidenceScore,
      'rejection_reason': rejectionReason,
      'uploaded_at': uploadedAt.toIso8601String(),
      'verified_at': verifiedAt?.toIso8601String(),
    };
  }
}

/// Trust score breakdown
class TrustScore {
  final double overallScore;
  final double verificationScore;
  final double activityScore;
  final double feedbackScore;
  final double outcomeScore;
  final int totalReviews;
  final int successfulOutcomes;
  final int complaints;
  final DateTime lastUpdated;

  const TrustScore({
    required this.overallScore,
    required this.verificationScore,
    required this.activityScore,
    required this.feedbackScore,
    required this.outcomeScore,
    this.totalReviews = 0,
    this.successfulOutcomes = 0,
    this.complaints = 0,
    required this.lastUpdated,
  });

  TrustLevel get level => TrustLevelExtension.fromScore(overallScore);

  factory TrustScore.fromJson(Map<String, dynamic> json) {
    return TrustScore(
      overallScore: (json['overall_score'] as num).toDouble(),
      verificationScore: (json['verification_score'] as num).toDouble(),
      activityScore: (json['activity_score'] as num).toDouble(),
      feedbackScore: (json['feedback_score'] as num).toDouble(),
      outcomeScore: (json['outcome_score'] as num).toDouble(),
      totalReviews: json['total_reviews'] as int? ?? 0,
      successfulOutcomes: json['successful_outcomes'] as int? ?? 0,
      complaints: json['complaints'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  factory TrustScore.empty() {
    return TrustScore(
      overallScore: 0,
      verificationScore: 0,
      activityScore: 0,
      feedbackScore: 0,
      outcomeScore: 0,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall_score': overallScore,
      'verification_score': verificationScore,
      'activity_score': activityScore,
      'feedback_score': feedbackScore,
      'outcome_score': outcomeScore,
      'total_reviews': totalReviews,
      'successful_outcomes': successfulOutcomes,
      'complaints': complaints,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}
