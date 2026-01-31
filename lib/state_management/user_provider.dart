import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/user_service.dart';
import 'package:global_trust_hub/core/api/api_exceptions.dart';

enum UserStatus {
  initial,
  loading,
  loaded,
  error,
}

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  
  UserStatus _status = UserStatus.initial;
  String? _errorMessage;
  UserProfile? _currentUser;

  UserStatus get status => _status;
  bool get isLoading => _status == UserStatus.loading;
  String? get errorMessage => _errorMessage;
  UserProfile? get currentUser => _currentUser;
  
  // Convenience getters
  String get userName => _currentUser?.fullName ?? 'Guest';
  String get userEmail => _currentUser?.email ?? '';
  double get trustScore => _currentUser?.trustScore ?? 0;
  bool get isVerified => _currentUser?.isVerified ?? false;
  String get userRole => _currentUser?.role ?? 'student';
  
  // Role-based helpers
  bool get isServiceProvider => userRole == 'service_provider' || userRole == 'agent';
  bool get isAdmin => userRole == 'admin';
  bool get isStudent => userRole == 'student';
  bool get isJobSeeker => userRole == 'job_seeker';

  /// Fetch current user profile
  Future<void> fetchCurrentUser() async {
    _status = UserStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _userService.getCurrentUser();
      _status = UserStatus.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = UserStatus.error;
    } catch (e) {
      _errorMessage = 'Failed to load profile';
      _status = UserStatus.error;
    }
    notifyListeners();
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? displayName,
    String? phone,
    String? bio,
    String? avatarUrl,
  }) async {
    _status = UserStatus.loading;
    notifyListeners();

    try {
      _currentUser = await _userService.updateProfile(
        fullName: fullName,
        displayName: displayName,
        phone: phone,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      _status = UserStatus.loaded;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = UserStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _userService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  /// Clear user data (on logout)
  void clear() {
    _currentUser = null;
    _status = UserStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

