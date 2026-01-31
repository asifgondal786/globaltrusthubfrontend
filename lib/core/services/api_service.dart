class ApiService {
  final String baseUrl = 'https://api.globaltrusthub.com';

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
