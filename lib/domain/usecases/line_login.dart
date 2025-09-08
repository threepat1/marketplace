import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';

class LineLogin implements UseCase<User, NoParams> {
  final AuthRepository repository;

  LineLogin(this.repository);

  @override
  Future<User> call(NoParams params) async {
    return await repository.lineLogin();
  }
}
