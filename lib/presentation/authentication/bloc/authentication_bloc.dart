import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/core/usecase.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/domain/usecases/get_auth_status.dart';
import 'package:marketplace/domain/usecases/logout.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetAuthStatus getAuthStatus;
  final Logout logout;

  AuthenticationBloc({required this.getAuthStatus, required this.logout})
      : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    final user = await getAuthStatus(NoParams());
    if (user != null) {
      emit(AuthenticationAuthenticated(user: user));
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    final user = await getAuthStatus(NoParams());
    if (user != null) {
      emit(AuthenticationAuthenticated(user: user));
    }
  }

  Future<void> _onLoggedOut(
      LoggedOut event, Emitter<AuthenticationState> emit) async {
    await logout(NoParams());
    emit(AuthenticationUnauthenticated());
  }
}
