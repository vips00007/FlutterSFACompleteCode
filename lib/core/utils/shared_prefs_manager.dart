import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';
  static const String _keyName = 'user_name';
  static const String _keyToken = 'access_token';
  static const String _keyTokenType = 'token_type';
  static const String _keyExpiresIn = 'expires_in';
  static const String _keyExpiresAt = 'expires_at';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyOnboardingComplete = 'onboarding_complete';

  // New keys for real API data
  static const String _keyUserUuid = 'user_uuid';
  static const String _keyCompanyUuid = 'company_uuid';
  static const String _keyCompanyCode = 'company_code';
  static const String _keyRoles = 'user_roles';
  static const String _keyMustChangePassword = 'must_change_password';
  static const String _keySessionMode = 'session_mode';
  static const String _keyChannel = 'channel';
  static const String _keyMobile = 'mobile_number';
  static const String _keyEmail = 'email';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Credentials
  static Future<void> saveCredentials(String username, String password) async {
    await _prefs?.setString(_keyUsername, username);
    await _prefs?.setString(_keyPassword, password);
  }

  static String? getSavedUsername() => _prefs?.getString(_keyUsername);
  static String? getSavedPassword() => _prefs?.getString(_keyPassword);

  static Future<void> saveName(String name) async {
    await _prefs?.setString(_keyName, name);
  }

  static String? getName() => _prefs?.getString(_keyName);

  static Future<void> clearCredentials() async {
    await _prefs?.remove(_keyUsername);
    await _prefs?.remove(_keyPassword);
  }

  // Session
  static Future<void> saveToken(String token) async {
    await _prefs?.setString(_keyToken, token);
  }

  static String? getToken() => _prefs?.getString(_keyToken);

  static Future<void> saveSessionData({
    required String token,
    required String tokenType,
    required int expiresIn,
    required String expiresAt,
    String? userUuid,
    String? username,
    String? displayName,
    String? companyUuid,
    String? companyCode,
    List<String>? roles,
    bool? mustChangePassword,
    String? sessionMode,
    String? channel,
  }) async {
    await _prefs?.setString(_keyToken, token);
    await _prefs?.setString(_keyTokenType, tokenType);
    await _prefs?.setInt(_keyExpiresIn, expiresIn);
    await _prefs?.setString(_keyExpiresAt, expiresAt);

    if (userUuid != null) await _prefs?.setString(_keyUserUuid, userUuid);
    if (username != null) await _prefs?.setString(_keyUsername, username);
    if (displayName != null) await _prefs?.setString(_keyName, displayName);
    if (companyUuid != null) {
      await _prefs?.setString(_keyCompanyUuid, companyUuid);
    }
    if (companyCode != null) {
      await _prefs?.setString(_keyCompanyCode, companyCode);
    }
    if (roles != null) await _prefs?.setString(_keyRoles, jsonEncode(roles));
    if (mustChangePassword != null) {
      await _prefs?.setBool(_keyMustChangePassword, mustChangePassword);
    }
    if (sessionMode != null) {
      await _prefs?.setString(_keySessionMode, sessionMode);
    }
    if (channel != null) await _prefs?.setString(_keyChannel, channel);
  }

  static String? getTokenType() => _prefs?.getString(_keyTokenType);
  static int? getExpiresIn() => _prefs?.getInt(_keyExpiresIn);
  static String? getExpiresAt() => _prefs?.getString(_keyExpiresAt);
  static String? getUserUuid() => _prefs?.getString(_keyUserUuid);
  static String? getCompanyUuid() => _prefs?.getString(_keyCompanyUuid);
  static String? getCompanyCode() => _prefs?.getString(_keyCompanyCode);
  static String? getSessionMode() => _prefs?.getString(_keySessionMode);
  static String? getChannel() => _prefs?.getString(_keyChannel);

  static List<String> getRoles() {
    final rolesJson = _prefs?.getString(_keyRoles);
    if (rolesJson != null) {
      try {
        return List<String>.from(jsonDecode(rolesJson));
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  static bool mustChangePassword() =>
      _prefs?.getBool(_keyMustChangePassword) ?? false;

  static Future<void> saveMobile(String mobile) async {
    await _prefs?.setString(_keyMobile, mobile);
  }

  static String? getMobile() => _prefs?.getString(_keyMobile);

  static Future<void> saveEmail(String email) async {
    await _prefs?.setString(_keyEmail, email);
  }

  static String? getEmail() => _prefs?.getString(_keyEmail);

  static Future<void> clearSession() async {
    await _prefs?.remove(_keyToken);
    await _prefs?.remove(_keyTokenType);
    await _prefs?.remove(_keyExpiresIn);
    await _prefs?.remove(_keyExpiresAt);
    await _prefs?.remove(_keyUserUuid);
    await _prefs?.remove(_keyCompanyUuid);
    await _prefs?.remove(_keyCompanyCode);
    await _prefs?.remove(_keyRoles);
    await _prefs?.remove(_keyMustChangePassword);
  }

  // Remember Me Flag
  static Future<void> setRememberMe(bool value) async {
    await _prefs?.setBool(_keyRememberMe, value);
  }

  static bool isRememberMeEnabled() => _prefs?.getBool(_keyRememberMe) ?? false;

  // Onboarding
  static Future<void> setOnboardingComplete(bool value) async {
    await _prefs?.setBool(_keyOnboardingComplete, value);
  }

  static bool isOnboardingComplete() =>
      _prefs?.getBool(_keyOnboardingComplete) ?? false;

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
