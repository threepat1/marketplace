import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/domain/usecases/login.dart';
import 'package:marketplace/presentation/authentication/bloc/authentication_bloc.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login loginUseCase;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.loginUseCase,
    required this.authenticationBloc,
  }) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await loginUseCase(
          LoginParams(username: event.username, password: event.password));
      authenticationBloc.add(LoggedIn(user: user));
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
