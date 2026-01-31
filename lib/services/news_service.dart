/// News API Service
/// Handles all news and updates related API calls

import 'package:global_trust_hub/core/api/api_client.dart';
import 'package:global_trust_hub/core/api/api_config.dart';

class NewsService {
  final ApiClient _api = ApiClient();

  /// Get latest news
  Future<NewsListResponse> getLatestNews({
    String? category,
    String? country,
    int limit = 10,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.news,
      queryParameters: {
        if (category != null) 'category': category,
        if (country != null) 'country': country,
        'limit': limit,
      },
    );
    return NewsListResponse.fromJson(response);
  }

  /// Get news detail
  Future<NewsItem> getNewsDetail(String newsId) async {
    final response = await _api.get<Map<String, dynamic>>(
      '${ApiConfig.news}/$newsId',
    );
    return NewsItem.fromJson(response);
  }
}

// Response Models

class NewsListResponse {
  final List<NewsItem> news;
  final int total;

  NewsListResponse({
    required this.news,
    required this.total,
  });

  factory NewsListResponse.fromJson(Map<String, dynamic> json) {
    return NewsListResponse(
      news: (json['news'] as List? ?? [])
          .map((n) => NewsItem.fromJson(n))
          .toList(),
      total: json['total'] ?? 0,
    );
  }
}

class NewsItem {
  final String id;
  final String title;
  final String? summary;
  final String? category;
  final String? country;
  final String timeAgo;
  final String? imageUrl;
  final String? url;

  NewsItem({
    required this.id,
    required this.title,
    this.summary,
    this.category,
    this.country,
    required this.timeAgo,
    this.imageUrl,
    this.url,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'],
      category: json['category'],
      country: json['country'],
      timeAgo: json['time_ago'] ?? '',
      imageUrl: json['image'],
      url: json['url'],
    );
  }
}
