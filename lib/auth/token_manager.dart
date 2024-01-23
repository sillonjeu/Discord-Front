import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await _getPrefs();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    final prefs = await _getPrefs();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}

