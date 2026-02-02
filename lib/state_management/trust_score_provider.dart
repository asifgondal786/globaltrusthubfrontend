import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/ml_service.dart';

enum TrustScoreStatus {
  initial,
  loading,
  loaded,
  error,
}

class TrustScoreProvider extends ChangeNotifier {
  final MLService _mlService = MLService();

  TrustScoreStatus _status = TrustScoreStatus.initial;
  String? _errorMessage;
  TrustScoreResponse? _currentScore;
  String? _userId;

  // Getters
  TrustScoreStatus get status => _status;
  bool get isLoading => _status == TrustScoreStatus.loading;
  String? get errorMessage => _errorMessage;
  TrustScoreResponse? get currentScore => _currentScore;
  
  double get trustScore => _currentScore?.trustScore ?? 0;
  String get trustLevel => _currentScore?.trustLevel ?? 'unverified';
  Map<String, double> get breakdown => _currentScore?.breakdown ?? {};
  List<String> get tips => _currentScore?.improvementTips ?? [];

  /// Calculate and load trust score for a user
  Future<void> calculateTrustScore({
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
    _userId = userId;
    _status = TrustScoreStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentScore = await _mlService.calculateTrustScore(
        userId: userId,
        verificationLevel: verificationLevel,
        documentsVerified: documentsVerified,
        identityConfirmed: identityConfirmed,
        successfulTransactions: successfulTransactions,
        failedTransactions: failedTransactions,
        totalValue: totalValue,
        disputeRate: disputeRate,
        totalReviews: totalReviews,
        averageRating: averageRating,
        verifiedReviews: verifiedReviews,
        daysActive: daysActive,
        loginFrequency: loginFrequency,
        profileCompleteness: profileCompleteness,
        responseRate: responseRate,
        reportedCount: reportedCount,
        scamFlags: scamFlags,
        positiveInteractions: positiveInteractions,
        communityContributions: communityContributions,
      );
      _status = TrustScoreStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to calculate trust score';
      _status = TrustScoreStatus.error;
    }
    notifyListeners();
  }

  /// Quick load with user profile data
  Future<void> loadForUser({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {
    await calculateTrustScore(
      userId: userId,
      verificationLevel: (profileData['verification_level'] as int?) ?? 0,
      documentsVerified: (profileData['documents_verified'] as int?) ?? 0,
      identityConfirmed: (profileData['identity_confirmed'] as bool?) ?? false,
      successfulTransactions: (profileData['successful_transactions'] as int?) ?? 0,
      failedTransactions: (profileData['failed_transactions'] as int?) ?? 0,
      totalValue: ((profileData['total_value'] as num?) ?? 0).toDouble(),
      disputeRate: ((profileData['dispute_rate'] as num?) ?? 0).toDouble(),
      totalReviews: (profileData['total_reviews'] as int?) ?? 0,
      averageRating: ((profileData['average_rating'] as num?) ?? 0).toDouble(),
      verifiedReviews: (profileData['verified_reviews'] as int?) ?? 0,
      daysActive: (profileData['days_active'] as int?) ?? 0,
      loginFrequency: ((profileData['login_frequency'] as num?) ?? 0).toDouble(),
      profileCompleteness: ((profileData['profile_completeness'] as num?) ?? 0).toDouble(),
      responseRate: ((profileData['response_rate'] as num?) ?? 0).toDouble(),
      reportedCount: (profileData['reported_count'] as int?) ?? 0,
      scamFlags: (profileData['scam_flags'] as int?) ?? 0,
      positiveInteractions: (profileData['positive_interactions'] as int?) ?? 0,
      communityContributions: (profileData['community_contributions'] as int?) ?? 0,
    );
  }

  /// Refresh trust score
  Future<void> refresh() async {
    if (_userId != null) {
      await calculateTrustScore(userId: _userId!);
    }
  }

  /// Get trust level color
  Color getTrustLevelColor() {
    switch (trustLevel) {
      case 'platinum':
        return const Color(0xFF9C27B0); // Purple
      case 'gold':
        return const Color(0xFFFFD700); // Gold
      case 'silver':
        return const Color(0xFFC0C0C0); // Silver
      case 'bronze':
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  /// Get progress to next level
  double getProgressToNextLevel() {
    final levels = {'unverified': 0, 'bronze': 200, 'silver': 400, 'gold': 600, 'platinum': 800};
    final currentThreshold = levels[trustLevel] ?? 0;
    
    String? nextLevel;
    int nextThreshold = 1000;
    
    final levelKeys = levels.keys.toList();
    final currentIndex = levelKeys.indexOf(trustLevel);
    if (currentIndex < levelKeys.length - 1) {
      nextLevel = levelKeys[currentIndex + 1];
      nextThreshold = levels[nextLevel]!;
    }
    
    if (nextLevel == null) return 1.0;
    
    final range = nextThreshold - currentThreshold;
    final progress = trustScore - currentThreshold;
    return (progress / range).clamp(0.0, 1.0);
  }

  /// Clear trust score
  void clear() {
    _currentScore = null;
    _status = TrustScoreStatus.initial;
    notifyListeners();
  }
}
