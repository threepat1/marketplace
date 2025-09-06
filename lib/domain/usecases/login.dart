import 'package:equatable/equatable.dart';
import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<User> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
