import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/job_service.dart';

enum JobStatus { initial, loading, loaded, error }

class JobProvider extends ChangeNotifier {
  final JobService _jobService = JobService();

  JobStatus _status = JobStatus.initial;
  String? _errorMessage;
  List<Job> _jobs = [];
  int _total = 0;
  int _page = 1;
  int _pageSize = 20;
  
  // Filter state
  String? _selectedCategory;
  String? _selectedCountry;
  bool? _remoteOnly;
  String? _selectedExperience;
  String? _searchQuery;

  // Getters
  JobStatus get status => _status;
  bool get isLoading => _status == JobStatus.loading;
  String? get errorMessage => _errorMessage;
  List<Job> get jobs => _jobs;
  int get total => _total;
  String? get selectedCategory => _selectedCategory;
  String? get selectedCountry => _selectedCountry;
  bool? get remoteOnly => _remoteOnly;
  String? get selectedExperience => _selectedExperience;

  /// Load jobs from API
  Future<void> loadJobs({
    String? category,
    String? country,
    bool? remote,
    String? experienceLevel,
    String? search,
    bool refresh = false,
  }) async {
    if (refresh) {
      _page = 1;
      _jobs = [];
    }
    
    _status = JobStatus.loading;
    _errorMessage = null;
    _selectedCategory = category;
    _selectedCountry = country;
    _remoteOnly = remote;
    _selectedExperience = experienceLevel;
    _searchQuery = search;
    notifyListeners();

    try {
      final response = await _jobService.getJobs(
        category: category,
        country: country,
        remote: remote,
        experienceLevel: experienceLevel,
        search: search,
        page: _page,
        pageSize: _pageSize,
      );
      
      _jobs = response.jobs;
      _total = response.total;
      _status = JobStatus.loaded;
      debugPrint('✅ Loaded ${_jobs.length} jobs (total: $_total)');
    } catch (e) {
      debugPrint('❌ Failed to load jobs: $e');
      _errorMessage = 'Failed to load jobs. Please try again.';
      _status = JobStatus.error;
    }
    notifyListeners();
  }

  /// Apply filters
  void applyFilters({
    String? category,
    String? country,
    bool? remote,
    String? experienceLevel,
  }) {
    loadJobs(
      category: category,
      country: country,
      remote: remote,
      experienceLevel: experienceLevel,
      search: _searchQuery,
      refresh: true,
    );
  }

  /// Search jobs
  void searchJobs(String query) {
    loadJobs(
      category: _selectedCategory,
      country: _selectedCountry,
      remote: _remoteOnly,
      experienceLevel: _selectedExperience,
      search: query.isEmpty ? null : query,
      refresh: true,
    );
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategory = null;
    _selectedCountry = null;
    _remoteOnly = null;
    _selectedExperience = null;
    _searchQuery = null;
    loadJobs(refresh: true);
  }

  /// Refresh jobs
  Future<void> refresh() async {
    await loadJobs(
      category: _selectedCategory,
      country: _selectedCountry,
      remote: _remoteOnly,
      experienceLevel: _selectedExperience,
      search: _searchQuery,
      refresh: true,
    );
  }
}
