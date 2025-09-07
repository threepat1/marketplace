import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/usecases/facebook_login.dart';
import 'package:marketplace/domain/usecases/google_login.dart';
import 'package:marketplace/domain/usecases/line_login.dart';
import 'package:marketplace/domain/usecases/login.dart';
import 'package:marketplace/presentation/authentication/bloc/authentication_bloc.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login loginUseCase;
  final GoogleLogin googleLoginUseCase;
  final FacebookLogin facebookLoginUseCase;
  final LineLogin lineLoginUseCase;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.loginUseCase,
    required this.googleLoginUseCase,
    required this.facebookLoginUseCase,
    required this.lineLoginUseCase,
    required this.authenticationBloc,
  }) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<GoogleLoginButtonPressed>(_onGoogleLoginButtonPressed);
    on<FacebookLoginButtonPressed>(_onFacebookLoginButtonPressed);
    on<LineLoginButtonPressed>(_onLineLoginButtonPressed);
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

  Future<void> _onGoogleLoginButtonPressed(
    GoogleLoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await googleLoginUseCase(NoParams());
      authenticationBloc.add(LoggedIn(user: user));
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }

  Future<void> _onFacebookLoginButtonPressed(
    FacebookLoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await facebookLoginUseCase(NoParams());
      authenticationBloc.add(LoggedIn(user: user));
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }

  Future<void> _onLineLoginButtonPressed(
    LineLoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await lineLoginUseCase(NoParams());
      authenticationBloc.add(LoggedIn(user: user));
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
