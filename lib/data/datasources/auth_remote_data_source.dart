import 'package:marketplace/domain/entities/user.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String username, String password);
  Future<void> register(String username, String password);
  Future<User> googleLogin();
  Future<User> facebookLogin();
  Future<User> lineLogin();
  Future<void> logout();
  Future<User?> getAuthStatus();
}

// Simulated implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  User? _currentUser;

  @override
  Future<User> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'flutter' && password == 'password') {
      _currentUser = const User(id: '123', name: 'FlutterDev');
      return _currentUser!;
    } else {
      throw Exception('Incorrect username or password.');
    }
  }

  @override
  Future<void> register(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you would send the registration data to your backend
    // and handle potential errors, like a username already being taken.
    print('User registered: $username');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<User?> getAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In a real app, you'd check for a saved token here
    return _currentUser;
  }

  @override
  Future<User> googleLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you would use the google_sign_in package to get the user's account
    // and then send the token to your backend to create or authenticate the user.
    _currentUser = const User(id: 'google_user_id', name: 'Google User');
    return _currentUser!;
  }

  @override
  Future<User> facebookLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you would use the flutter_facebook_auth package to get the user's account
    // and then send the token to your backend to create or authenticate the user.
    _currentUser = const User(id: 'facebook_user_id', name: 'Facebook User');
    return _currentUser!;
  }

  @override
  Future<User> lineLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you would use the flutter_line_sdk package to get the user's account
    // and then send the token to your backend to create or authenticate the user.
    _currentUser = const User(id: 'line_user_id', name: 'Line User');
    return _currentUser!;
  }
}
