import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/auth_service.dart';
import 'package:global_trust_hub/core/api/api_exceptions.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  // SecureStorageService is accessed via AuthService
  
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  AuthResponse? _authResponse;

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  String? get errorMessage => _errorMessage;
  AuthResponse? get authResponse => _authResponse;

  /// Initialize - check if user is already logged in
  Future<void> initialize() async {
    _status = AuthStatus.loading;
    notifyListeners();
    
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      _status = isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Login with email and password
  Future<bool> login(String email, String password, {bool rememberMe = false}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _authResponse = await _authService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'student',
    String userType = 'student',
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
        userType: userType,
      );
      _status = AuthStatus.unauthenticated; // User needs to verify email
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();
    
    try {
      await _authService.logout();
    } finally {
      _authResponse = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  /// Request password reset
  Future<bool> forgotPassword(String email) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.forgotPassword(email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}

