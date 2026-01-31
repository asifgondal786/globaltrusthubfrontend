import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/services_service.dart';
import 'package:global_trust_hub/core/api/api_exceptions.dart';

enum ServicesStatus {
  initial,
  loading,
  loaded,
  error,
}

class ServicesProvider extends ChangeNotifier {
  final ServicesService _servicesService = ServicesService();
  
  ServicesStatus _status = ServicesStatus.initial;
  String? _errorMessage;
  
  // Data
  List<ServiceItem> _services = [];
  List<ServiceCategory> _categories = [];
  FeaturedServicesResponse? _featured;
  ServiceDetail? _selectedService;
  
  // Pagination
  int _currentPage = 1;
  int _totalCount = 0;
  bool _hasMore = true;
  
  // Filters
  String? _categoryFilter;
  String? _countryFilter;
  int _minTrustScore = 0;

  // Getters
  ServicesStatus get status => _status;
  bool get isLoading => _status == ServicesStatus.loading;
  String? get errorMessage => _errorMessage;
  List<ServiceItem> get services => _services;
  List<ServiceCategory> get categories => _categories;
  FeaturedServicesResponse? get featured => _featured;
  ServiceDetail? get selectedService => _selectedService;
  bool get hasMore => _hasMore;

  /// Load service categories
  Future<void> loadCategories() async {
    try {
      final response = await _servicesService.getCategories();
      _categories = response.categories;
      notifyListeners();
    } catch (_) {
      // Categories are non-critical, silently fail
    }
  }

  /// Load featured services
  Future<void> loadFeatured() async {
    try {
      _featured = await _servicesService.getFeatured();
      notifyListeners();
    } catch (_) {
      // Featured are non-critical
    }
  }

  /// Load services with filters
  Future<void> loadServices({
    String? category,
    String? country,
    int minTrustScore = 0,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _services = [];
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _status = ServicesStatus.loading;
    _errorMessage = null;
    _categoryFilter = category ?? _categoryFilter;
    _countryFilter = country ?? _countryFilter;
    _minTrustScore = minTrustScore;
    notifyListeners();

    try {
      final response = await _servicesService.listServices(
        category: _categoryFilter,
        country: _countryFilter,
        minTrustScore: _minTrustScore,
        page: _currentPage,
      );
      
      _services.addAll(response.services);
      _totalCount = response.total;
      _hasMore = _services.length < _totalCount;
      _currentPage++;
      _status = ServicesStatus.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = ServicesStatus.error;
    } catch (e) {
      _errorMessage = 'Failed to load services';
      _status = ServicesStatus.error;
    }
    notifyListeners();
  }

  /// Load next page
  Future<void> loadMore() async {
    if (!_hasMore || _status == ServicesStatus.loading) return;
    await loadServices();
  }

  /// Get service details
  Future<void> loadServiceDetail(String serviceId) async {
    _status = ServicesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedService = await _servicesService.getServiceDetail(serviceId);
      _status = ServicesStatus.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = ServicesStatus.error;
    }
    notifyListeners();
  }

  /// Contact a service provider
  Future<Map<String, dynamic>?> contactService(String serviceId, String message) async {
    try {
      return await _servicesService.contactService(serviceId, message);
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return null;
    }
  }

  /// Clear filters and refresh
  void clearFilters() {
    _categoryFilter = null;
    _countryFilter = null;
    _minTrustScore = 0;
    loadServices(refresh: true);
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
