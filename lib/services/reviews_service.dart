/// Reviews API Service
/// Handles all review and rating related API calls
library reviews_service;

import 'package:global_trust_hub/core/api/api_client.dart';
import 'package:global_trust_hub/core/api/api_config.dart';

class ReviewsService {
  final ApiClient _api = ApiClient();

  /// List reviews for a target entity
  Future<ReviewsListResponse> listReviews({
    required String targetId,
    required String targetType,
    int page = 1,
    int perPage = 20,
    String sortBy = 'recent',
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.reviews,
      queryParameters: {
        'target_id': targetId,
        'target_type': targetType,
        'page': page,
        'per_page': perPage,
        'sort_by': sortBy,
      },
    );
    return ReviewsListResponse.fromJson(response);
  }

  /// Get current user's reviews
  Future<Map<String, dynamic>> getMyReviews({int page = 1}) async {
    return await _api.get<Map<String, dynamic>>(
      ApiConfig.myReviews,
      queryParameters: {'page': page},
    );
  }

  /// Create a new review
  Future<ReviewResponse> createReview({
    required String targetId,
    required String targetType,
    required int rating,
    required String title,
    required String content,
    String? transactionId,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConfig.reviews,
      data: {
        'target_id': targetId,
        'target_type': targetType,
        'rating': rating,
        'title': title,
        'content': content,
        if (transactionId != null) 'transaction_id': transactionId,
      },
    );
    return ReviewResponse.fromJson(response);
  }

  /// Get a specific review
  Future<ReviewResponse> getReview(String reviewId) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.reviewDetail(reviewId),
    );
    return ReviewResponse.fromJson(response);
  }

  /// Update a review
  Future<ReviewResponse> updateReview(String reviewId, {
    int? rating,
    String? title,
    String? content,
  }) async {
    final response = await _api.patch<Map<String, dynamic>>(
      ApiConfig.reviewDetail(reviewId),
      data: {
        if (rating != null) 'rating': rating,
        if (title != null) 'title': title,
        if (content != null) 'content': content,
      },
    );
    return ReviewResponse.fromJson(response);
  }

  /// Delete a review
  Future<void> deleteReview(String reviewId) async {
    await _api.delete(ApiConfig.reviewDetail(reviewId));
  }

  /// Mark a review as helpful
  Future<Map<String, dynamic>> markHelpful(String reviewId, {bool helpful = true}) async {
    return await _api.post<Map<String, dynamic>>(
      ApiConfig.reviewHelpful(reviewId),
      data: {'helpful': helpful},
    );
  }

  /// Report a review
  Future<Map<String, dynamic>> reportReview(String reviewId, String reason) async {
    return await _api.post<Map<String, dynamic>>(
      ApiConfig.reviewReport(reviewId),
      data: {'reason': reason},
    );
  }
}

// Response Models

class ReviewsListResponse {
  final List<ReviewResponse> reviews;
  final int total;
  final int page;
  final int perPage;
  final double averageRating;
  final Map<String, int> ratingDistribution;

  ReviewsListResponse({
    required this.reviews,
    required this.total,
    required this.page,
    required this.perPage,
    required this.averageRating,
    required this.ratingDistribution,
  });

  factory ReviewsListResponse.fromJson(Map<String, dynamic> json) {
    return ReviewsListResponse(
      reviews: (json['reviews'] as List? ?? [])
          .map((r) => ReviewResponse.fromJson(r))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      ratingDistribution: Map<String, int>.from(json['rating_distribution'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ReviewResponse {
  final String id;
  final String reviewerId;
  final String targetId;
  final String targetType;
  final int rating;
  final String title;
  final String content;
  final bool isVerifiedTransaction;
  final String status;
  final int helpfulCount;
  final String createdAt;

  ReviewResponse({
    required this.id,
    required this.reviewerId,
    required this.targetId,
    required this.targetType,
    required this.rating,
    required this.title,
    required this.content,
    required this.isVerifiedTransaction,
    required this.status,
    required this.helpfulCount,
    required this.createdAt,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['id'] as String? ?? '',
      reviewerId: json['reviewer_id'] as String? ?? '',
      targetId: json['target_id'] as String? ?? '',
      targetType: json['target_type'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isVerifiedTransaction: json['is_verified_transaction'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending',
      helpfulCount: json['helpful_count'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
