class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  Future<bool> signup(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
  
  Future<void> logout() async {
    // clear tokens
  }
}
