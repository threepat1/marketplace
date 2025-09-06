import 'package:marketplace/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String username, String password);
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
}
