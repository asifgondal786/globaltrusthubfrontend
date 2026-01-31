import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/ml_service.dart';

enum RecommendationsStatus {
  initial,
  loading,
  loaded,
  error,
}

class RecommendationsProvider extends ChangeNotifier {
  final MLService _mlService = MLService();

  RecommendationsStatus _status = RecommendationsStatus.initial;
  String? _errorMessage;
  List<RecommendationItem> _recommendations = [];
  String? _userId;

  // Getters
  RecommendationsStatus get status => _status;
  bool get isLoading => _status == RecommendationsStatus.loading;
  String? get errorMessage => _errorMessage;
  List<RecommendationItem> get recommendations => _recommendations;
  List<RecommendationItem> get universities => 
      _recommendations.where((r) => r.category == 'university').toList();
  List<RecommendationItem> get agents => 
      _recommendations.where((r) => r.category == 'agent').toList();
  List<RecommendationItem> get jobs => 
      _recommendations.where((r) => r.category == 'job').toList();

  /// Load personalized recommendations for a user
  Future<void> loadRecommendations({
    required String userId,
    String? category,
    int limit = 10,
  }) async {
    _userId = userId;
    _status = RecommendationsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _mlService.getRecommendations(
        userId: userId,
        category: category,
        limit: limit,
      );
      
      _recommendations = response.recommendations;
      _status = RecommendationsStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load recommendations';
      _status = RecommendationsStatus.error;
    }
    notifyListeners();
  }

  /// Refresh recommendations
  Future<void> refresh() async {
    if (_userId != null) {
      await loadRecommendations(userId: _userId!);
    }
  }

  /// Get top recommendation by category
  RecommendationItem? getTopByCategory(String category) {
    final filtered = _recommendations.where((r) => r.category == category).toList();
    if (filtered.isEmpty) return null;
    filtered.sort((a, b) => b.score.compareTo(a.score));
    return filtered.first;
  }

  /// Clear recommendations
  void clear() {
    _recommendations = [];
    _status = RecommendationsStatus.initial;
    notifyListeners();
  }
}
