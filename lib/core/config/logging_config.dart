class LoggingConfig {
  static const String logLevel = 'info'; // debug | info | warning | error
  static const bool auditLogEnabled = true;

  static const List<String> securityEventTracking = [
    'failed_login',
    'password_change',
    'suspicious_activity',
    'admin_access',
  ];

  static const Map<String, int> alertThresholds = {
    'failed_logins_per_minute': 10,
    'api_error_rate_percent': 5,
  };

  static const List<String> incidentNotificationChannels = ['email', 'slack'];
}
