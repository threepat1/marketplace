import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.logout();
  }
}
