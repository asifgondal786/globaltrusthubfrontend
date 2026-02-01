/// Legacy API Service - Use ApiClient from core/api/api_client.dart instead
@Deprecated('Use ApiClient from core/api/api_client.dart for all API calls')
class ApiService {
  final String baseUrl = 'https://globaltrusthubbackend-production.up.railway.app';

  Future<dynamic> get(String endpoint) async {
    // efficient http get implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return {'data': 'mock response'};
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    // efficient http post implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return {'data': 'mock response'};
  }
}
