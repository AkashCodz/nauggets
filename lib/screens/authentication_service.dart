import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  static const String _keyAuthenticated = 'authenticated';
  static const String _keyToken = 'token';

  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAuthenticated) ?? false;
  }

  static Future<void> setAuthenticated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuthenticated, value);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthenticated);
    await prefs.remove(_keyToken);
  }
}
