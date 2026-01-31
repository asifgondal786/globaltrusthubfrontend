class AdminConfig {
  static const List<String> adminRoles = ['super_admin', 'content_manager', 'support_lead'];

  static const Map<String, List<String>> moderatorPermissions = {
    'junior_mod': ['view_reports', 'flag_content'],
    'senior_mod': ['view_reports', 'flag_content', 'suspend_user', 'delete_content'],
  };

  static const Map<String, dynamic> actionApprovalRules = {
    'ban_user': 'requires_senior_approval',
    'refund_payment': 'requires_finance_approval',
  };

  static const bool auditVisibility = true; // Admins can see who viewed what

  static const Map<String, bool> emergencyShutdownRules = {
    'allow_full_lockdown': true,
    'allow_payment_freeze': true,
  };
}
