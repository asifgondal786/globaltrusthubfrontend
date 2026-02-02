import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/api/api_config.dart';

/// Employer model
class Employer {
  final String id;
  final String name;
  final String? logoUrl;
  final String industry;
  final String companySize;
  final String location;
  final String? website;
  final bool verified;
  final double? rating;
  final int reviewCount;

  Employer({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.industry,
    required this.companySize,
    required this.location,
    this.website,
    this.verified = false,
    this.rating,
    this.reviewCount = 0,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logo_url'] as String?,
      industry: json['industry'] as String? ?? '',
      companySize: json['company_size'] as String? ?? '',
      location: json['location'] as String? ?? '',
      website: json['website'] as String?,
      verified: json['verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int? ?? 0,
    );
  }
}

/// Job model
class Job {
  final String id;
  final String title;
  final Employer employer;
  final String location;
  final String country;
  final int? salaryMin;
  final int? salaryMax;
  final String salaryCurrency;
  final String salaryPeriod;
  final String jobType;
  final bool remote;
  final String category;
  final String experienceLevel;
  final String description;
  final List<String> requirements;
  final List<String> benefits;
  final String postedDate;
  final String? applicationDeadline;
  final int applicants;
  final String source;
  final String applyUrl;
  final bool isSponsored;

  Job({
    required this.id,
    required this.title,
    required this.employer,
    required this.location,
    required this.country,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency = 'USD',
    this.salaryPeriod = 'yearly',
    required this.jobType,
    this.remote = false,
    required this.category,
    required this.experienceLevel,
    required this.description,
    required this.requirements,
    required this.benefits,
    required this.postedDate,
    this.applicationDeadline,
    this.applicants = 0,
    required this.source,
    required this.applyUrl,
    this.isSponsored = false,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      employer: Employer.fromJson(json['employer'] as Map<String, dynamic>? ?? {}),
      location: json['location'] as String? ?? '',
      country: json['country'] as String? ?? '',
      salaryMin: json['salary_min'] as int?,
      salaryMax: json['salary_max'] as int?,
      salaryCurrency: json['salary_currency'] as String? ?? 'USD',
      salaryPeriod: json['salary_period'] as String? ?? 'yearly',
      jobType: json['job_type'] as String? ?? '',
      remote: json['remote'] as bool? ?? false,
      category: json['category'] as String? ?? '',
      experienceLevel: json['experience_level'] as String? ?? '',
      description: json['description'] as String? ?? '',
      requirements: (json['requirements'] as List? ?? []).map((e) => e as String).toList(),
      benefits: (json['benefits'] as List? ?? []).map((e) => e as String).toList(),
      postedDate: json['posted_date'] as String? ?? '',
      applicationDeadline: json['application_deadline'] as String?,
      applicants: json['applicants'] as int? ?? 0,
      source: json['source'] as String? ?? '',
      applyUrl: json['apply_url'] as String? ?? '',
      isSponsored: json['is_sponsored'] as bool? ?? false,
    );
  }

  String get salaryDisplay {
    if (salaryMin == null && salaryMax == null) return 'Competitive';
    
    String formatSalary(int amount) {
      if (amount >= 1000) {
        return '${(amount / 1000).toStringAsFixed(0)}K';
      }
      return amount.toString();
    }
    
    String symbol = _getCurrencySymbol(salaryCurrency);
    String period = salaryPeriod == 'yearly' ? '/yr' : salaryPeriod == 'monthly' ? '/mo' : '/hr';
    
    if (salaryMin != null && salaryMax != null) {
      return '$symbol${formatSalary(salaryMin!)} - $symbol${formatSalary(salaryMax!)}$period';
    } else if (salaryMin != null) {
      return 'From $symbol${formatSalary(salaryMin!)}$period';
    } else {
      return 'Up to $symbol${formatSalary(salaryMax!)}$period';
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD': return '\$';
      case 'GBP': return '£';
      case 'EUR': return '€';
      case 'CAD': return 'C\$';
      case 'AUD': return 'A\$';
      case 'AED': return 'AED ';
      default: return '$currency ';
    }
  }

  String get postedAgo {
    try {
      final posted = DateTime.parse(postedDate);
      final now = DateTime.now();
      final difference = now.difference(posted);
      
      if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} months ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return postedDate;
    }
  }
}

/// Jobs API Response
class JobsResponse {
  final List<Job> jobs;
  final int total;
  final int page;
  final int pageSize;

  JobsResponse({
    required this.jobs,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) {
    final jobList = (json['jobs'] as List?)
        ?.map((j) => Job.fromJson(j as Map<String, dynamic>))
        .toList() ?? [];
    return JobsResponse(
      jobs: jobList,
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 10,
    );
  }
}

/// Job Service
class JobService {
  final Dio _dio;
  
  JobService() : _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),);

  Future<JobsResponse> getJobs({
    String? category,
    String? country,
    bool? remote,
    String? experienceLevel,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };
      
      if (category != null) queryParams['category'] = category;
      if (country != null) queryParams['country'] = country;
      if (remote != null) queryParams['remote'] = remote;
      if (experienceLevel != null) queryParams['experience_level'] = experienceLevel;
      if (search != null) queryParams['search'] = search;

      final response = await _dio.get('/api/v1/jobs', queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;
      debugPrint('✅ Jobs API: ${data['total']} jobs loaded');
      return JobsResponse.fromJson(data);
    } catch (e) {
      debugPrint('❌ Jobs API error: $e');
      rethrow;
    }
  }

  Future<Job> getJobDetails(String jobId) async {
    try {
      final response = await _dio.get('/api/v1/jobs/$jobId');
      return Job.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Job details API error: $e');
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/api/v1/jobs/categories');
      final data = response.data as Map<String, dynamic>;
      return List<String>.from(data['categories'] ?? []);
    } catch (e) {
      return ['Technology', 'Finance', 'Healthcare', 'Design', 'Marketing'];
    }
  }

  Future<List<String>> getCountries() async {
    try {
      final response = await _dio.get('/api/v1/jobs/countries');
      final data = response.data as Map<String, dynamic>;
      return List<String>.from(data['countries'] ?? []);
    } catch (e) {
      return ['USA', 'UK', 'Canada', 'Australia', 'Germany'];
    }
  }
}
