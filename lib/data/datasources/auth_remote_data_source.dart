import 'dart:convert';

import 'package:marketplace/config/app_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:marketplace/domain/entities/user.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

abstract class AuthRemoteDataSource {
  Future<User> googleLogin();
  Future<User> facebookLogin();
  Future<User> lineLogin();
  Future<void> logout();
  Future<User?> getAuthStatus();
  Future<User> updateProfile(String userId, Map<String, dynamic> fields);
}

// Simulated implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({http.Client? client, FlutterSecureStorage? storage})
      : _client = client ?? http.Client(),
        _secureStorage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';

  final http.Client _client;
  final FlutterSecureStorage _secureStorage;
  User? _currentUser;

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<User?> getAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final token = await _secureStorage.read(key: _tokenKey);
    if (token == null) {
      return null;
    }
    return _currentUser;
  }

  @override
  Future<User> updateProfile(String userId, Map<String, dynamic> fields) async {
    final token = await _secureStorage.read(key: _tokenKey);
    final response = await _client.patch(
      Uri.parse('${AppConfig.apiBaseUrl}/api/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(fields),
    );

    if (response.statusCode != 200) {
      final message = _extractError(response.body);
      throw Exception(message);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final userMap =
        (data['user'] as Map<String, dynamic>?) ?? data; // fallback to root
    _currentUser = _userFromJson(userMap);
    return _currentUser!;
  }

  @override
  Future<User> googleLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    final account = await GoogleSignIn().signIn();
    if (account == null) {
      throw Exception('Google sign in aborted');
    }
    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw Exception('Failed to obtain Google id token');
    }

    final response = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_token': idToken}),
    );

    if (response.statusCode != 200) {
      final message = _extractError(response.body);
      throw Exception(message);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final token = data['token'] as String;
    final complete = data['complete'] as bool? ?? false;
    _currentUser =
        _userFromJson(data['user'] as Map<String, dynamic>, complete: complete);
    await _secureStorage.write(key: _tokenKey, value: token);
    return _currentUser!;
  }

  @override
  Future<User> facebookLogin() async {
    final result = await FacebookAuth.instance.login(
      permissions: const ['id', 'email', 'name', 'birthday'],
    );

    if (result.status != LoginStatus.success || result.accessToken == null) {
      throw Exception(result.message ?? 'Facebook login failed');
    }
    final accessToken = result.accessToken!.token;

    final response = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/auth/facebook'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'access_token': accessToken}),
    );
    if (response.statusCode != 200) {
      final message = _extractError(response.body);
      throw Exception(message);
    }
    // Return _currentUser

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final token = data['token'] as String;
    final complete = data['complete'] as bool? ?? false;
    _currentUser =
        _userFromJson(data['user'] as Map<String, dynamic>, complete: complete);
    await _secureStorage.write(key: _tokenKey, value: token);
    return _currentUser!;
  }

  @override
  Future<User> lineLogin() async {
    final result = await LineSDK.instance.login();
    final accessToken = result.accessToken.value;
    if (accessToken.isEmpty) {
      throw Exception('Failed to obtain LINE access token');
    }

    final response = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/auth/line'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'access_token': accessToken}),
    );

    if (response.statusCode != 200) {
      final message = _extractError(response.body);
      throw Exception(message);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final token = data['token'] as String;
    final complete = data['complete'] as bool? ?? false;
    _currentUser =
        _userFromJson(data['user'] as Map<String, dynamic>, complete: complete);
    await _secureStorage.write(key: _tokenKey, value: token);
    return _currentUser!;
  }

  User _userFromJson(Map<String, dynamic> json, {bool complete = false}) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
      email: json['email'] as String?,
      birthday: json['birthday'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      subDistrict:
          json['sub_district'] as String? ?? json['subDistrict'] as String?,
      district: json['district'] as String?,
      province: json['province'] as String?,
      phoneNumber:
          json['phone_number'] as String? ?? json['phoneNumber'] as String?,
      complete: complete,
    );
  }

  String _extractError(String body) {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(body);
      return jsonMap['error']?.toString() ?? body;
    } catch (_) {
      return body;
    }
  }
}
