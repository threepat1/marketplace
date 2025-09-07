import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';

class GoogleLogin implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GoogleLogin(this.repository);

  @override
  Future<User> call(NoParams params) async {
    return await repository.googleLogin();
  }
}
