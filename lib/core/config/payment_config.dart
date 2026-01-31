class PaymentConfig {
  static const Map<String, dynamic> subscriptionPlans = {
    'agent': {
      'monthly': 49.99,
      'yearly': 499.99,
      'features': ['verified_badge', 'priority_support', 'unlimited_posts'],
    },
    'institution': {
      'monthly': 199.99,
      'yearly': 1999.99,
    },
  };

  static const String currency = 'USD';
  static const String billingCycle = 'monthly'; // monthly | yearly
  static const int gracePeriodDays = 3;
  
  static const Map<String, dynamic> refundPolicy = {
    'window_days': 14,
    'conditions': 'No active service usage',
  };

  static const List<String> paymentProviders = ['stripe', 'paypal'];
  static const bool autoGenerateInvoices = true;
}
