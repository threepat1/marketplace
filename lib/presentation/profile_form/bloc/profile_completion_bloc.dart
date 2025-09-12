import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/data/datasources/auth_remote_data_source.dart';

// --- Events ---
abstract class ProfileCompletionEvent extends Equatable {
  const ProfileCompletionEvent();
  @override
  List<Object> get props => [];
}

class ProfileSubmitted extends ProfileCompletionEvent {
  final User user;
  final String newName;
  final String newSurname;
  final String newEmail;
  final String newBirthday;
  final String newGender;

  const ProfileSubmitted({
    required this.user,
    required this.newName,
    required this.newSurname,
    required this.newEmail,
    required this.newBirthday,
    required this.newGender,
  });

  @override
  List<Object> get props =>
      [user, newName, newSurname, newEmail, newBirthday, newGender];
}

// --- States ---
abstract class ProfileCompletionState extends Equatable {
  const ProfileCompletionState();
  @override
  List<Object> get props => [];
}

class ProfileFormClosed extends ProfileCompletionEvent {}

class ProfileInitial extends ProfileCompletionState {}

class ProfileLoading extends ProfileCompletionState {}

class ProfileSuccess extends ProfileCompletionState {
  final User user;

  const ProfileSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileFailure extends ProfileCompletionState {
  final String error;

  const ProfileFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// --- BLoC Implementation ---
class ProfileCompletionBloc
    extends Bloc<ProfileCompletionEvent, ProfileCompletionState> {
  final AuthRemoteDataSource _authRemoteDataSource;

  ProfileCompletionBloc({AuthRemoteDataSource? authRemoteDataSource})
      : _authRemoteDataSource =
            authRemoteDataSource ?? AuthRemoteDataSourceImpl(),
        super(ProfileInitial()) {
    on<ProfileSubmitted>(_onProfileSubmitted);
    on<ProfileFormClosed>(_onProfileFormClosed);
  }
  void _onProfileFormClosed(
    ProfileFormClosed event,
    Emitter<ProfileCompletionState> emit,
  ) {
    // This state can be used to tell the LoginBloc that the user did not complete the profile.
    emit(ProfileFailure(error: 'Profile completion was canceled.'));
  }

  Future<void> _onProfileSubmitted(
    ProfileSubmitted event,
    Emitter<ProfileCompletionState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      // Simulate an API call to a backend to update the user's profile.
      final updatedUser = await _authRemoteDataSource.updateProfile(
        event.user.id,
        {
          'name': event.newName,
          'surname': event.newSurname,
          'email': event.newEmail,
          'birthday': event.newBirthday,
          'gender': event.newGender,
          'complete': true
        },
      );

      emit(ProfileSuccess(user: updatedUser));
    } catch (error) {
      emit(ProfileFailure(error: error.toString()));
    }
  }
}
