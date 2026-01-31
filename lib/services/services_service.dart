/// Services API Service
/// Handles all service provider related API calls

import 'package:global_trust_hub/core/api/api_client.dart';
import 'package:global_trust_hub/core/api/api_config.dart';

class ServicesService {
  final ApiClient _api = ApiClient();

  /// List services with filters
  Future<ServicesListResponse> listServices({
    String? category,
    String? country,
    bool verifiedOnly = true,
    int minTrustScore = 0,
    int page = 1,
    int perPage = 20,
    String sortBy = 'trust_score',
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.services,
      queryParameters: {
        if (category != null) 'category': category,
        if (country != null) 'country': country,
        'verified_only': verifiedOnly,
        'min_trust_score': minTrustScore,
        'page': page,
        'per_page': perPage,
        'sort_by': sortBy,
      },
    );
    return ServicesListResponse.fromJson(response);
  }

  /// Get featured services
  Future<FeaturedServicesResponse> getFeatured() async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.featuredServices,
    );
    return FeaturedServicesResponse.fromJson(response);
  }

  /// Get service categories
  Future<CategoriesResponse> getCategories() async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.serviceCategories,
    );
    return CategoriesResponse.fromJson(response);
  }

  /// Get service details
  Future<ServiceDetail> getServiceDetail(String serviceId) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.serviceDetail(serviceId),
    );
    return ServiceDetail.fromJson(response);
  }

  /// List universities
  Future<Map<String, dynamic>> listUniversities({
    String? country,
    String? program,
    int page = 1,
  }) async {
    return await _api.get<Map<String, dynamic>>(
      ApiConfig.universities,
      queryParameters: {
        if (country != null) 'country': country,
        if (program != null) 'program': program,
        'page': page,
      },
    );
  }

  /// List education agents
  Future<Map<String, dynamic>> listAgents({
    String? specialization,
    String? country,
    int page = 1,
  }) async {
    return await _api.get<Map<String, dynamic>>(
      ApiConfig.agents,
      queryParameters: {
        if (specialization != null) 'specialization': specialization,
        if (country != null) 'country': country,
        'page': page,
      },
    );
  }

  /// List jobs
  Future<Map<String, dynamic>> listJobs({
    String? category,
    String? location,
    bool? remote,
    int page = 1,
  }) async {
    return await _api.get<Map<String, dynamic>>(
      ApiConfig.jobs,
      queryParameters: {
        if (category != null) 'category': category,
        if (location != null) 'location': location,
        if (remote != null) 'remote': remote,
        'page': page,
      },
    );
  }

  /// Contact a service provider
  Future<Map<String, dynamic>> contactService(String serviceId, String message) async {
    return await _api.post<Map<String, dynamic>>(
      ApiConfig.contactService(serviceId),
      data: {'message': message},
    );
  }
}

// Response Models

class ServicesListResponse {
  final List<ServiceItem> services;
  final int total;
  final int page;
  final Map<String, dynamic>? filtersApplied;

  ServicesListResponse({
    required this.services,
    required this.total,
    required this.page,
    this.filtersApplied,
  });

  factory ServicesListResponse.fromJson(Map<String, dynamic> json) {
    return ServicesListResponse(
      services: (json['services'] as List? ?? [])
          .map((s) => ServiceItem.fromJson(s))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      filtersApplied: json['filters_applied'],
    );
  }
}

class ServiceItem {
  final String id;
  final String name;
  final String category;
  final int trustScore;
  final double rating;
  final int reviewsCount;

  ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.trustScore,
    required this.rating,
    required this.reviewsCount,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      trustScore: json['trust_score'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
    );
  }
}

class ServiceDetail extends ServiceItem {
  final String? description;
  final String? country;
  final bool isVerified;

  ServiceDetail({
    required super.id,
    required super.name,
    required super.category,
    required super.trustScore,
    required super.rating,
    required super.reviewsCount,
    this.description,
    this.country,
    this.isVerified = false,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      trustScore: json['trust_score'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      description: json['description'],
      country: json['country'],
      isVerified: json['is_verified'] ?? false,
    );
  }
}

class FeaturedServicesResponse {
  final Map<String, dynamic>? agentOfMonth;
  final Map<String, dynamic>? universityOfMonth;
  final Map<String, dynamic>? employerOfMonth;
  final List<ServiceItem> featuredProviders;

  FeaturedServicesResponse({
    this.agentOfMonth,
    this.universityOfMonth,
    this.employerOfMonth,
    required this.featuredProviders,
  });

  factory FeaturedServicesResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedServicesResponse(
      agentOfMonth: json['agent_of_month'],
      universityOfMonth: json['university_of_month'],
      employerOfMonth: json['employer_of_month'],
      featuredProviders: (json['featured_providers'] as List? ?? [])
          .map((s) => ServiceItem.fromJson(s))
          .toList(),
    );
  }
}

class CategoriesResponse {
  final List<ServiceCategory> categories;

  CategoriesResponse({required this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      categories: (json['categories'] as List? ?? [])
          .map((c) => ServiceCategory.fromJson(c))
          .toList(),
    );
  }
}

class ServiceCategory {
  final String id;
  final String name;
  final int count;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.count,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
