import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/domain/usecases/register.dart';
import 'package:marketplace/presentation/register/bloc/register_event.dart';
import 'package:marketplace/presentation/register/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Register registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        await registerUseCase(
          RegisterParams(
            username: event.username,
            password: event.password,
          ),
        );
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }
}
