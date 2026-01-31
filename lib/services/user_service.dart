/// User Service
/// Handles all user-related API calls

import 'package:global_trust_hub/core/api/api_client.dart';
import 'package:global_trust_hub/core/api/api_config.dart';

class UserService {
  final ApiClient _api = ApiClient();

  /// Get current authenticated user's profile
  Future<UserProfile> getCurrentUser() async {
    final response = await _api.get<Map<String, dynamic>>(ApiConfig.currentUser);
    return UserProfile.fromJson(response);
  }

  /// Update current user's profile
  Future<UserProfile> updateProfile({
    String? fullName,
    String? displayName,
    String? phone,
    String? bio,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{};
    if (fullName != null) data['full_name'] = fullName;
    if (displayName != null) data['display_name'] = displayName;
    if (phone != null) data['phone'] = phone;
    if (bio != null) data['bio'] = bio;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;

    final response = await _api.patch<Map<String, dynamic>>(
      ApiConfig.updateProfile,
      data: data,
    );
    return UserProfile.fromJson(response);
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _api.post(
      ApiConfig.changePassword,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  /// Get a user's public profile
  Future<UserPublicProfile> getUserProfile(String userId) async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.userProfile(userId),
    );
    return UserPublicProfile.fromJson(response);
  }

  /// Update verification information
  Future<UserProfile> updateVerification({
    String? cnicNumber,
    String? passportNumber,
    String? address,
    String? domicile,
  }) async {
    final data = <String, dynamic>{};
    if (cnicNumber != null) data['cnic_number'] = cnicNumber;
    if (passportNumber != null) data['passport_number'] = passportNumber;
    if (address != null) data['address'] = address;
    if (domicile != null) data['domicile'] = domicile;

    final response = await _api.patch<Map<String, dynamic>>(
      ApiConfig.updateVerification,
      data: data,
    );
    return UserProfile.fromJson(response);
  }
}

// Response Models

class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? displayName;
  final String? phone;
  final String? bio;
  final String? avatarUrl;
  final String role;
  final bool isVerified;
  final String verificationStatus;
  final double trustScore;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.displayName,
    this.phone,
    this.bio,
    this.avatarUrl,
    required this.role,
    required this.isVerified,
    required this.verificationStatus,
    required this.trustScore,
    required this.isActive,
    required this.createdAt,
    this.lastLogin,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      displayName: json['display_name'],
      phone: json['phone'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      role: json['role'] ?? 'student',
      isVerified: json['is_verified'] ?? false,
      verificationStatus: json['verification_status'] ?? 'unverified',
      trustScore: (json['trust_score'] ?? 0).toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      lastLogin: json['last_login'] != null 
          ? DateTime.parse(json['last_login']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'display_name': displayName,
      'phone': phone,
      'bio': bio,
      'avatar_url': avatarUrl,
      'role': role,
      'is_verified': isVerified,
      'verification_status': verificationStatus,
      'trust_score': trustScore,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}

class UserPublicProfile {
  final String id;
  final String fullName;
  final String? displayName;
  final String? avatarUrl;
  final String role;
  final bool isVerified;
  final double trustScore;

  UserPublicProfile({
    required this.id,
    required this.fullName,
    this.displayName,
    this.avatarUrl,
    required this.role,
    required this.isVerified,
    required this.trustScore,
  });

  factory UserPublicProfile.fromJson(Map<String, dynamic> json) {
    return UserPublicProfile(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      role: json['role'] ?? 'student',
      isVerified: json['is_verified'] ?? false,
      trustScore: (json['trust_score'] ?? 0).toDouble(),
    );
  }
}
