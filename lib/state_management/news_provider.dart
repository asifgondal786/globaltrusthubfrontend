import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/news_service.dart';
import 'package:global_trust_hub/core/api/api_exceptions.dart';

enum NewsStatus {
  initial,
  loading,
  loaded,
  error,
}

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  
  NewsStatus _status = NewsStatus.initial;
  String? _errorMessage;
  List<NewsItem> _news = [];
  int _total = 0;

  NewsStatus get status => _status;
  bool get isLoading => _status == NewsStatus.loading;
  String? get errorMessage => _errorMessage;
  List<NewsItem> get news => _news;
  int get total => _total;

  // Fallback news data when API is unavailable
  static final List<NewsItem> _fallbackNews = [
    NewsItem(
      id: 'fallback_001',
      title: 'UK Updates Work Visa Rules',
      summary: 'New changes to graduate work visa allow extended stay for international students.',
      category: 'visa',
      country: 'UK',
      timeAgo: '2h ago',
    ),
    NewsItem(
      id: 'fallback_002',
      title: 'Canada Increases Student Work Hours',
      summary: 'International students can now work up to 24 hours per week during study periods.',
      category: 'education',
      country: 'Canada',
      timeAgo: '4h ago',
    ),
    NewsItem(
      id: 'fallback_003',
      title: 'Australia Eases Travel Restrictions',
      summary: 'Simplified visa processing for skilled workers and students from partner countries.',
      category: 'travel',
      country: 'Australia',
      timeAgo: '6h ago',
    ),
    NewsItem(
      id: 'fallback_004',
      title: 'Harvard Opens New AI Research Center',
      summary: 'State-of-the-art facility with \$500M investment opens for international researchers.',
      category: 'university',
      country: 'USA',
      timeAgo: '3h ago',
    ),
    NewsItem(
      id: 'fallback_005',
      title: 'Germany Fast-Tracks Student Visa',
      summary: 'New express processing for qualified international students - 2 weeks approval.',
      category: 'visa',
      country: 'Germany',
      timeAgo: '8h ago',
    ),
    NewsItem(
      id: 'fallback_006',
      title: 'London Student Housing Crisis Eases',
      summary: 'New affordable student accommodations open near major universities.',
      category: 'accommodation',
      country: 'UK',
      timeAgo: '7h ago',
    ),
    NewsItem(
      id: 'fallback_007',
      title: 'US Tech Companies Increase H1B Sponsorship',
      summary: 'Major tech firms announce plans to sponsor 50% more international talent.',
      category: 'employment',
      country: 'USA',
      timeAgo: '5h ago',
    ),
  ];

  /// Load latest news
  Future<void> loadNews({
    String? category,
    String? country,
    int limit = 10,
  }) async {
    _status = NewsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _newsService.getLatestNews(
        category: category,
        country: country,
        limit: limit,
      );
      _news = response.news;
      _total = response.total;
      _status = NewsStatus.loaded;
      debugPrint('✅ News loaded: ${_news.length} items');
    } on ApiException catch (e) {
      debugPrint('❌ News API error: ${e.message}');
      _errorMessage = e.message;
      // Use fallback data on error
      _useFallbackNews(category, limit);
    } catch (e) {
      debugPrint('❌ News error: $e');
      _errorMessage = 'Failed to load news';
      // Use fallback data on error
      _useFallbackNews(category, limit);
    }
    notifyListeners();
  }

  /// Use fallback news data when API is unavailable
  void _useFallbackNews(String? category, int limit) {
    List<NewsItem> fallback = _fallbackNews;
    
    // Filter by category if provided
    if (category != null) {
      fallback = fallback.where((n) => n.category == category).toList();
    }
    
    _news = fallback.take(limit).toList();
    _total = fallback.length;
    _status = NewsStatus.loaded;
    debugPrint('📰 Using fallback news: ${_news.length} items');
  }

  /// Refresh news
  Future<void> refresh() async {
    await loadNews();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
