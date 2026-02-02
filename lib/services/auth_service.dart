/// Auth Service
/// Handles all authentication API calls
library auth_service;

import 'package:global_trust_hub/core/api/api_client.dart';
import 'package:global_trust_hub/core/api/api_config.dart';
import 'package:global_trust_hub/core/storage/secure_storage.dart';

class AuthService {
  final ApiClient _api = ApiClient();
  final SecureStorageService _storage = SecureStorageService();

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConfig.login,
      data: {
        'email': email,
        'password': password,
        'remember_me': rememberMe,
      },
    );

    final authResponse = AuthResponse.fromJson(response);
    
    // Save tokens
    await _storage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );
    
    if (authResponse.user != null) {
      await _storage.saveUserId(authResponse.user!['id'] ?? '');
    }

    return authResponse;
  }

  /// Register new user
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'student',
    String userType = 'student',
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConfig.register,
      data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone': phone,
        'role': role,
        'user_type': userType,
      },
    );

    return RegisterResponse.fromJson(response);
  }

  /// Refresh access token
  Future<TokenResponse> refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await _api.post<Map<String, dynamic>>(
      ApiConfig.refreshToken,
      data: {'refresh_token': refreshToken},
    );

    final tokenResponse = TokenResponse.fromJson(response);
    await _storage.saveAccessToken(tokenResponse.accessToken);

    return tokenResponse;
  }

  /// Request password reset
  Future<void> forgotPassword(String email) async {
    await _api.post(
      ApiConfig.forgotPassword,
      data: {'email': email},
    );
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _api.post(
      ApiConfig.resetPassword,
      data: {
        'token': token,
        'new_password': newPassword,
      },
    );
  }

  /// Verify email with token
  Future<void> verifyEmail(String token) async {
    await _api.post(
      ApiConfig.verifyEmail,
      data: {'token': token},
    );
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _api.post(ApiConfig.logout);
    } finally {
      await _storage.clearAll();
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  /// Admin login
  Future<AuthResponse> adminLogin({
    required String email,
    required String password,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConfig.adminLogin,
      data: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response);
    
    // Save tokens
    await _storage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );
    
    if (authResponse.user != null) {
      await _storage.saveUserId(authResponse.user!['id'] ?? '');
    }

    return authResponse;
  }

  /// Resend verification email
  Future<void> resendVerification(String email) async {
    await _api.post(
      ApiConfig.resendVerification,
      data: {'email': email},
    );
  }
}

// Response Models

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final Map<String, dynamic>? user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'bearer',
    required this.expiresIn,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'] ?? 1800,
      user: json['user'],
    );
  }
}

class RegisterResponse {
  final String message;
  final String userId;
  final String email;
  final bool requiresVerification;

  RegisterResponse({
    required this.message,
    required this.userId,
    required this.email,
    this.requiresVerification = true,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] ?? '',
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      requiresVerification: json['requires_verification'] ?? true,
    );
  }
}

class TokenResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  TokenResponse({
    required this.accessToken,
    this.tokenType = 'bearer',
    required this.expiresIn,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'] ?? 1800,
    );
  }
}
