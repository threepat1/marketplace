import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/domain/usecases/facebook_login.dart';
import 'package:marketplace/domain/usecases/google_login.dart';
import 'package:marketplace/domain/usecases/line_login.dart';
import 'package:marketplace/presentation/authentication/bloc/authentication_bloc.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GoogleLogin googleLoginUseCase;
  final FacebookLogin facebookLoginUseCase;
  final LineLogin lineLoginUseCase;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.googleLoginUseCase,
    required this.facebookLoginUseCase,
    required this.lineLoginUseCase,
    required this.authenticationBloc,
  }) : super(LoginInitial()) {
    on<GoogleLoginButtonPressed>(_onGoogleLoginButtonPressed);
    on<FacebookLoginButtonPressed>(_onFacebookLoginButtonPressed);
    on<LineLoginButtonPressed>(_onLineLoginButtonPressed);
    on<ProfileSubmittedCompleted>(
        (event, emit) => emit(LoginCompleted())); // Add this handler
  }

  Future<void> _onGoogleLoginButtonPressed(
    GoogleLoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await googleLoginUseCase(NoParams());
      authenticationBloc.add(LoggedIn());
      _checkProfileStatusAndEmit(user, emit);
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
      authenticationBloc.add(LoggedIn());
      _checkProfileStatusAndEmit(user, emit);
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
      authenticationBloc.add(LoggedIn());
      _checkProfileStatusAndEmit(user, emit);
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }

  // A helper method to check the user's profile completeness.
  void _checkProfileStatusAndEmit(User user, Emitter<LoginState> emit) {
    if (user.complete) {
      emit(LoginCompleted());
    } else {
      emit(LoginSuccess(user: user));
    }
  }
}
