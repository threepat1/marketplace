import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';
import 'package:marketplace/domain/usecases/login.dart';
import 'package:marketplace/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:marketplace/presentation/login/bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login to Bid')),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            loginUseCase: Login(context.read<AuthRepository>()),
          );
        },
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController(text: 'flutter');
  final _passwordController = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      context.read<LoginBloc>().add(
            LoginButtonPressed(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is LoginSuccess) {
          // THIS IS THE FIX:
          // We only pop the navigator if this page was pushed onto the stack.
          // If it was built directly (like in the MainScreen tab), we do nothing,
          // because the MainScreen's BlocBuilder will handle the UI update.
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(true);
          }
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      labelText: 'Username', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                if (state is LoginLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _onLoginButtonPressed,
                    child: const Text('LOGIN'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
