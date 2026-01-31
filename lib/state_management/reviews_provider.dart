import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/reviews_service.dart';
import 'package:global_trust_hub/core/api/api_exceptions.dart';

enum ReviewsStatus {
  initial,
  loading,
  loaded,
  submitting,
  error,
}

class ReviewsProvider extends ChangeNotifier {
  final ReviewsService _reviewsService = ReviewsService();
  
  ReviewsStatus _status = ReviewsStatus.initial;
  String? _errorMessage;
  
  // Data
  List<ReviewResponse> _reviews = [];
  double _averageRating = 0;
  Map<String, int> _ratingDistribution = {};
  
  // Pagination
  int _currentPage = 1;
  int _totalCount = 0;
  bool _hasMore = true;
  
  // Current target
  String? _targetId;
  String? _targetType;

  // Getters
  ReviewsStatus get status => _status;
  bool get isLoading => _status == ReviewsStatus.loading;
  bool get isSubmitting => _status == ReviewsStatus.submitting;
  String? get errorMessage => _errorMessage;
  List<ReviewResponse> get reviews => _reviews;
  double get averageRating => _averageRating;
  Map<String, int> get ratingDistribution => _ratingDistribution;
  bool get hasMore => _hasMore;

  /// Load reviews for an entity
  Future<void> loadReviews({
    required String targetId,
    required String targetType,
    String sortBy = 'recent',
    bool refresh = false,
  }) async {
    if (refresh || _targetId != targetId) {
      _currentPage = 1;
      _reviews = [];
      _hasMore = true;
      _targetId = targetId;
      _targetType = targetType;
    }

    if (!_hasMore && !refresh) return;

    _status = ReviewsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _reviewsService.listReviews(
        targetId: targetId,
        targetType: targetType,
        page: _currentPage,
        sortBy: sortBy,
      );
      
      _reviews.addAll(response.reviews);
      _totalCount = response.total;
      _averageRating = response.averageRating;
      _ratingDistribution = response.ratingDistribution;
      _hasMore = _reviews.length < _totalCount;
      _currentPage++;
      _status = ReviewsStatus.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = ReviewsStatus.error;
    } catch (e) {
      _errorMessage = 'Failed to load reviews';
      _status = ReviewsStatus.error;
    }
    notifyListeners();
  }

  /// Load more reviews
  Future<void> loadMore() async {
    if (!_hasMore || _status == ReviewsStatus.loading) return;
    if (_targetId == null || _targetType == null) return;
    
    await loadReviews(targetId: _targetId!, targetType: _targetType!);
  }

  /// Submit a new review
  Future<bool> submitReview({
    required String targetId,
    required String targetType,
    required int rating,
    required String title,
    required String content,
    String? transactionId,
  }) async {
    _status = ReviewsStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final newReview = await _reviewsService.createReview(
        targetId: targetId,
        targetType: targetType,
        rating: rating,
        title: title,
        content: content,
        transactionId: transactionId,
      );
      
      // Add to top of list
      _reviews.insert(0, newReview);
      _status = ReviewsStatus.loaded;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = ReviewsStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Mark review as helpful
  Future<void> markHelpful(String reviewId, {bool helpful = true}) async {
    try {
      await _reviewsService.markHelpful(reviewId, helpful: helpful);
      // Update local state
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        // In a real app, update the helpful count
        notifyListeners();
      }
    } catch (_) {
      // Non-critical, silently fail
    }
  }

  /// Report a review
  Future<bool> reportReview(String reviewId, String reason) async {
    try {
      await _reviewsService.reportReview(reviewId, reason);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  /// Clear reviews (when navigating away)
  void clear() {
    _reviews = [];
    _currentPage = 1;
    _hasMore = true;
    _targetId = null;
    _targetType = null;
    _status = ReviewsStatus.initial;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
