/// API Configuration
/// Base URLs and endpoint paths for GlobalTrustHub API

class ApiConfig {
  // Base URL - change for production
  // static const String baseUrl = 'https://globaltrusthubbackend-production.up.railway.app';
  static const String baseUrl = 'http://127.0.0.1:8080';
  static const String apiVersion = '/api/v1';
  
  // Full API base path
  static String get apiBaseUrl => '$baseUrl$apiVersion';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String adminLogin = '/auth/admin/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendVerification = '/auth/resend-verification';
  static const String logout = '/auth/logout';
  
  // User endpoints
  static const String currentUser = '/users/me';
  static const String updateProfile = '/users/me';
  static const String changePassword = '/users/me/change-password';
  static const String updateVerification = '/users/me/verification';
  static String userProfile(String userId) => '/users/$userId';
  
  // Services endpoints
  static const String services = '/services';
  static const String featuredServices = '/services/featured';
  static const String serviceCategories = '/services/categories';
  static const String universities = '/services/universities';
  static const String agents = '/services/agents';
  static const String jobs = '/services/jobs';
  static const String housing = '/services/housing';
  static String serviceDetail(String id) => '/services/$id';
  static String contactService(String id) => '/services/$id/contact';
  
  // Reviews endpoints
  static const String reviews = '/reviews';
  static const String myReviews = '/reviews/my-reviews';
  static String reviewDetail(String id) => '/reviews/$id';
  static String reviewHelpful(String id) => '/reviews/$id/helpful';
  static String reviewReport(String id) => '/reviews/$id/report';
  
  // Chat endpoints
  static const String chatRooms = '/chat/rooms';
  static String chatRoom(String roomId) => '/chat/rooms/$roomId';
  static String chatMessages(String roomId) => '/chat/rooms/$roomId/messages';
  static String freezeChat(String roomId) => '/chat/rooms/$roomId/freeze';
  
  // Payments endpoints
  static const String payments = '/payments';
  static const String paymentMethods = '/payments/methods';
  
  // Verification endpoints
  static const String verification = '/verification';
  
  // Health check
  static const String healthCheck = '/health';
  
  // News endpoints
  static const String news = '/news';
  static String newsDetail(String id) => '/news/$id';
  
  // Journey endpoints
  static const String journeys = '/journey';
  static const String journeyProgress = '/journey/my-progress';
  static String journeyTemplate(String id) => '/journey/templates/$id';

  // ML endpoints
  static const String mlTrustScore = '/ml/trust-score';
  static const String mlFraudCheck = '/ml/fraud-check';
  static const String mlRecommendations = '/ml/recommendations';
  static const String mlHealth = '/ml/health';
}
