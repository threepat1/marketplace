import 'package:marketplace/domain/entities/user.dart';

abstract class AuthRepository {
  Future<void> register(String username, String password);
  Future<User> googleLogin();
  Future<User> facebookLogin();
  Future<User> lineLogin();
  Future<void> logout();
  Future<User?> getAuthStatus();
}
