import 'package:marketplace/data/datasources/auth_remote_data_source.dart';
import 'package:marketplace/data/datasources/user_local_data_source.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> googleLogin() async {
    await remoteDataSource.googleLogin();
    return localDataSource.loadUser();
  }

  @override
  Future<User> facebookLogin() async {
    await remoteDataSource.facebookLogin();
    return localDataSource.loadUser();
  }

  @override
  Future<User> lineLogin() async {
    await remoteDataSource.lineLogin();
    return localDataSource.loadUser();
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<User?> getAuthStatus() async {
    try {
      return await localDataSource.loadUser();
    } catch (_) {
      return null;
    }
  }
}
