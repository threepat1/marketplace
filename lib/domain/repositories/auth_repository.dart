import 'package:marketplace/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<void> register(String username, String password);
  Future<User> googleLogin();
  Future<User> facebookLogin();
  Future<User> lineLogin();
  Future<void> logout();
  Future<User?> getAuthStatus();
}
