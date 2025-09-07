import 'package:marketplace/domain/entities/user.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

abstract class AuthRemoteDataSource {
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
  Future<void> register(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));

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
    _currentUser =
        const User(id: 'google_user_id', name: 'Google User', surname: '');
    return _currentUser!;
  }

  @override
  @override
  Future<User> facebookLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    final result = await FacebookAuth.i.login(
      permissions: [
        'email',
        'public_profile',
        'user_birthday',
        'user_friends',
        'user_gender',
        'user_link'
      ],
    );
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200),birthday,gender",
      );
      // Insert the user data into _currentUser
      _currentUser = User(
        id: '',
        name: userData['name'] as String,
        surname: '',
        email: userData['email'] as String?,
        birthday: userData['birthday'] as String?,
        gender: userData['gender'] as String?,
      );
    } else {
      // Handle login failure
      // For example, throw an exception
      throw Exception('Facebook login failed: ${result.message}');
    }
    // Return _currentUser
    return _currentUser!;
  }

  @override
  Future<User> lineLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    final result = await LineSDK.instance.login();
    if (result.accessToken.value != null || result.accessToken.value != "") {
      final userData = await LineSDK.instance.getProfile();
      _currentUser = User(
        id: 'backend_gen_id_3',
        name: userData.displayName,
        surname: '', // LINE API doesn't provide a separate surname
        email: null,
        birthday: null,
        gender: null,
      );
    }

    return _currentUser!;
  }
}
