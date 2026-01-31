/// ML Service
/// Handles Machine Learning API calls for trust scores, fraud detection, and recommendations

import 'package:global_trust_hub/core/api/api_client.dart';
import 'package:global_trust_hub/core/api/api_config.dart';

class MLService {
  final ApiClient _api = ApiClient();

  /// Calculate trust score for a user using ML
  Future<TrustScoreResponse> calculateTrustScore({
    required String userId,
    int verificationLevel = 0,
    int documentsVerified = 0,
    bool identityConfirmed = false,
    int successfulTransactions = 0,
    int failedTransactions = 0,
    double totalValue = 0.0,
    double disputeRate = 0.0,
    int totalReviews = 0,
    double averageRating = 0.0,
    int verifiedReviews = 0,
    int daysActive = 0,
    double loginFrequency = 0.0,
    double profileCompleteness = 0.0,
    double responseRate = 0.0,
    int reportedCount = 0,
    int scamFlags = 0,
    int positiveInteractions = 0,
    int communityContributions = 0,
  }) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        ApiConfig.mlTrustScore,
        data: {
          'user_id': userId,
          'verification_level': verificationLevel,
          'documents_verified': documentsVerified,
          'identity_confirmed': identityConfirmed,
          'successful_transactions': successfulTransactions,
          'failed_transactions': failedTransactions,
          'total_value': totalValue,
          'dispute_rate': disputeRate,
          'total_reviews': totalReviews,
          'average_rating': averageRating,
          'verified_reviews': verifiedReviews,
          'days_active': daysActive,
          'login_frequency': loginFrequency,
          'profile_completeness': profileCompleteness,
          'response_rate': responseRate,
          'reported_count': reportedCount,
          'scam_flags': scamFlags,
          'positive_interactions': positiveInteractions,
          'community_contributions': communityContributions,
        },
      );
      return TrustScoreResponse.fromJson(response);
    } catch (e) {
      // Return mock data on error
      return TrustScoreResponse(
        userId: userId,
        trustScore: 500,
        trustLevel: 'silver',
        breakdown: {
          'verification': 60.0,
          'transactions': 40.0,
          'reviews': 50.0,
          'activity': 30.0,
          'behavior': 45.0,
        },
        improvementTips: ['Complete identity verification', 'Get more reviews'],
      );
    }
  }

  /// Check text for fraud/scam indicators
  Future<FraudCheckResponse> checkFraud({
    required String text,
    String? context,
  }) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        ApiConfig.mlFraudCheck,
        data: {
          'text': text,
          if (context != null) 'context': context,
        },
      );
      return FraudCheckResponse.fromJson(response);
    } catch (e) {
      return FraudCheckResponse(
        isSuspicious: false,
        confidence: 0.0,
        riskLevel: 'low',
        flags: [],
        explanation: 'Unable to analyze text',
      );
    }
  }

  /// Get personalized recommendations for a user
  Future<RecommendationsResponse> getRecommendations({
    required String userId,
    String? category,
    int limit = 10,
  }) async {
    try {
      final response = await _api.get<Map<String, dynamic>>(
        '${ApiConfig.mlRecommendations}/$userId',
        queryParameters: {
          if (category != null) 'category': category,
          'limit': limit,
        },
      );
      return RecommendationsResponse.fromJson(response);
    } catch (e) {
      return RecommendationsResponse(
        userId: userId,
        recommendations: _getMockRecommendations(),
      );
    }
  }

  List<RecommendationItem> _getMockRecommendations() {
    return [
      RecommendationItem(
        id: 'uni_001',
        name: 'Harvard University',
        category: 'university',
        score: 0.95,
        reason: 'Top-rated in your preferred field of study',
      ),
      RecommendationItem(
        id: 'agent_001',
        name: 'Ali Travel Consultants',
        category: 'agent',
        score: 0.92,
        reason: 'Highly rated for UK visa applications',
      ),
      RecommendationItem(
        id: 'job_001',
        name: 'Software Engineer at Tech Innovate',
        category: 'job',
        score: 0.88,
        reason: 'Matches your skills and location preference',
      ),
    ];
  }
}

// Response Models

class TrustScoreResponse {
  final String userId;
  final double trustScore;
  final String trustLevel;
  final Map<String, double> breakdown;
  final List<String> improvementTips;

  TrustScoreResponse({
    required this.userId,
    required this.trustScore,
    required this.trustLevel,
    required this.breakdown,
    required this.improvementTips,
  });

  factory TrustScoreResponse.fromJson(Map<String, dynamic> json) {
    return TrustScoreResponse(
      userId: json['user_id'] ?? '',
      trustScore: (json['trust_score'] ?? 0).toDouble(),
      trustLevel: json['trust_level'] ?? 'unverified',
      breakdown: Map<String, double>.from(
        (json['breakdown'] ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
      improvementTips: List<String>.from(json['improvement_tips'] ?? []),
    );
  }
}

class FraudCheckResponse {
  final bool isSuspicious;
  final double confidence;
  final String riskLevel;
  final List<String> flags;
  final String explanation;

  FraudCheckResponse({
    required this.isSuspicious,
    required this.confidence,
    required this.riskLevel,
    required this.flags,
    required this.explanation,
  });

  factory FraudCheckResponse.fromJson(Map<String, dynamic> json) {
    return FraudCheckResponse(
      isSuspicious: json['is_suspicious'] ?? false,
      confidence: (json['confidence'] ?? 0).toDouble(),
      riskLevel: json['risk_level'] ?? 'low',
      flags: List<String>.from(json['flags'] ?? []),
      explanation: json['explanation'] ?? '',
    );
  }
}

class RecommendationsResponse {
  final String userId;
  final List<RecommendationItem> recommendations;

  RecommendationsResponse({
    required this.userId,
    required this.recommendations,
  });

  factory RecommendationsResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationsResponse(
      userId: json['user_id'] ?? '',
      recommendations: (json['recommendations'] as List? ?? [])
          .map((r) => RecommendationItem.fromJson(r))
          .toList(),
    );
  }
}

class RecommendationItem {
  final String id;
  final String name;
  final String category;
  final double score;
  final String reason;

  RecommendationItem({
    required this.id,
    required this.name,
    required this.category,
    required this.score,
    required this.reason,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      reason: json['reason'] ?? '',
    );
  }
}
