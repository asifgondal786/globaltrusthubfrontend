import 'package:global_trust_hub/models/enums.dart';

/// User model representing all user types in GlobalTrustHub
class User {
  final String id;
  final String email;
  final String? phone;
  final String? fullName;
  final String? avatarUrl;
  final UserRole role;
  final double trustScore;
  final int verificationLevel;
  final SubscriptionStatus subscriptionStatus;
  final DateTime createdAt;
  final DateTime? lastActiveAt;
  final UserProfile? profile;

  const User({
    required this.id,
    required this.email,
    this.phone,
    this.fullName,
    this.avatarUrl,
    required this.role,
    this.trustScore = 0,
    this.verificationLevel = 0,
    this.subscriptionStatus = SubscriptionStatus.free,
    required this.createdAt,
    this.lastActiveAt,
    this.profile,
  });

  TrustLevel get trustLevel => TrustLevelExtension.fromScore(trustScore);

  bool get isVerified => verificationLevel >= 2;

  bool get hasActiveSubscription =>
      role == UserRole.student || subscriptionStatus == SubscriptionStatus.active;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.student,
      ),
      trustScore: (json['trust_score'] as num?)?.toDouble() ?? 0,
      verificationLevel: json['verification_level'] as int? ?? 0,
      subscriptionStatus: SubscriptionStatus.values.firstWhere(
        (s) => s.name == json['subscription_status'],
        orElse: () => SubscriptionStatus.free,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'] as String)
          : null,
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role.name,
      'trust_score': trustScore,
      'verification_level': verificationLevel,
      'subscription_status': subscriptionStatus.name,
      'created_at': createdAt.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
      'profile': profile?.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? fullName,
    String? avatarUrl,
    UserRole? role,
    double? trustScore,
    int? verificationLevel,
    SubscriptionStatus? subscriptionStatus,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    UserProfile? profile,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      trustScore: trustScore ?? this.trustScore,
      verificationLevel: verificationLevel ?? this.verificationLevel,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      profile: profile ?? this.profile,
    );
  }
}

/// Extended profile information based on user role
class UserProfile {
  // Common fields
  final String? nationality;
  final String? address;
  final DateTime? dateOfBirth;

  // Student-specific
  final String? currentEducation;
  final String? targetCountry;
  final String? intendedStudyField;

  // Agent-specific
  final String? businessName;
  final String? licenseNumber;
  final List<String>? servicesOffered;

  // Institution-specific
  final String? institutionType;
  final String? website;
  final String? registrationNumber;

  // Provider-specific
  final String? providerType;
  final String? serviceDescription;

  const UserProfile({
    this.nationality,
    this.address,
    this.dateOfBirth,
    this.currentEducation,
    this.targetCountry,
    this.intendedStudyField,
    this.businessName,
    this.licenseNumber,
    this.servicesOffered,
    this.institutionType,
    this.website,
    this.registrationNumber,
    this.providerType,
    this.serviceDescription,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nationality: json['nationality'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      currentEducation: json['current_education'] as String?,
      targetCountry: json['target_country'] as String?,
      intendedStudyField: json['intended_study_field'] as String?,
      businessName: json['business_name'] as String?,
      licenseNumber: json['license_number'] as String?,
      servicesOffered: (json['services_offered'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      institutionType: json['institution_type'] as String?,
      website: json['website'] as String?,
      registrationNumber: json['registration_number'] as String?,
      providerType: json['provider_type'] as String?,
      serviceDescription: json['service_description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nationality': nationality,
      'address': address,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'current_education': currentEducation,
      'target_country': targetCountry,
      'intended_study_field': intendedStudyField,
      'business_name': businessName,
      'license_number': licenseNumber,
      'services_offered': servicesOffered,
      'institution_type': institutionType,
      'website': website,
      'registration_number': registrationNumber,
      'provider_type': providerType,
      'service_description': serviceDescription,
    };
  }
}
