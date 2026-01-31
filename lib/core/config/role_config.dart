class RoleConfig {
  static const List<String> roles = [
    'student',
    'job_seeker',
    'agent',
    'university',
    'employer',
    'landlord',
    'bank',
    'admin',
    'moderator',
  ];

  static const Map<String, Map<String, dynamic>> rolePermissions = {
    'student': {
      'can_chat_with': ['university', 'agent', 'employer'],
      'can_post_services': false,
      'requires_verification_level': 1,
      'subscription_required': false,
      'daily_action_limits': 100,
    },
    'agent': {
      'can_chat_with': ['student', 'university'],
      'can_post_services': true,
      'requires_verification_level': 3,
      'subscription_required': true,
      'daily_action_limits': 500,
    },
    // Define other roles similarly
  };
}
