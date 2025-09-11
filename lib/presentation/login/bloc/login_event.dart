part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class GoogleLoginButtonPressed extends LoginEvent {}

class FacebookLoginButtonPressed extends LoginEvent {}

class LineLoginButtonPressed extends LoginEvent {}

// Add this new event
class ProfileSubmittedCompleted extends LoginEvent {}
