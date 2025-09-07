import 'package:equatable/equatable.dart';
import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';

class Register implements UseCase<void, RegisterParams> {
  final AuthRepository repository;

  Register(this.repository);

  @override
  Future<void> call(RegisterParams params) async {
    return await repository.register(params.username, params.password);
  }
}

class RegisterParams extends Equatable {
  final String username;
  final String password;

  const RegisterParams({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
