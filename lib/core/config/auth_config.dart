class AuthConfig {
  static const List<String> loginMethods = ['email_password', 'otp_email'];

  static const Map<String, dynamic> passwordPolicy = {
    'min_length': 8,
    'complexity_rules': {
      'require_uppercase': true,
      'require_lowercase': true,
      'require_digits': true,
      'require_special_char': true,
    },
  };

  static const Map<String, dynamic> sessionPolicy = {
    'access_token_expiry': '15m',
    'refresh_token_expiry': '7d',
  };

  static const Map<String, dynamic> otpPolicy = {
    'otp_length': 6,
    'expiry_time': '5m',
    'max_attempts': 3,
  };

  static const int deviceLimitPerUser = 3;
  static const Map<String, dynamic> accountLockPolicy = {
    'max_failed_attempts': 5,
    'lock_duration': '30m',
  };
}
