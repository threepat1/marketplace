import 'package:marketplace/data/datasources/auth_remote_data_source.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String username, String password) {
    return remoteDataSource.login(username, password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<User?> getAuthStatus() {
    return remoteDataSource.getAuthStatus();
  }
}
