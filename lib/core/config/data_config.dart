class DataConfig {
  static const Map<String, String> dataRetentionPeriods = {
    'user_logs': '90d',
    'chat_history': '365d',
    'transaction_records': '7y',
    'deleted_account_metadata': '30d',
  };

  static const String encryptionStandard = 'AES-256';
  static const Map<String, String> regionalStorageRules = {
    'EU': 'eu-central-1', // GDPR requirement
    'US': 'us-east-1',
    'Global': 'us-east-1',
  };

  static const bool accessLogsEnabled = true;
  static const bool userDataExportEnabled = true;

  static const Map<String, dynamic> rightToDeletePolicy = {
    'grace_period': '30d',
    'verification_required': true,
  };
}
