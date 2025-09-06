part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  // 1. CHANGE THE PROPERTY from a String to the User entity
  final User user;

  // 2. UPDATE THE CONSTRUCTOR to accept the User entity
  const AuthenticationAuthenticated({required this.user});

  // 3. UPDATE THE PROPS for Equatable
  @override
  List<Object> get props => [user];
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
