import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';
import 'package:marketplace/domain/usecases/register.dart';
import 'package:marketplace/presentation/login/bloc/login_bloc.dart';
import 'package:marketplace/presentation/register/bloc/register_bloc.dart';
import 'package:marketplace/presentation/register/bloc/register_event.dart';
import 'package:marketplace/presentation/register/bloc/register_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocProvider(
        create: (context) {
          return RegisterBloc(
            registerUseCase: Register(context.read<AuthRepository>()),
          );
        },
        child: const RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onRegisterButtonPressed() {
      if (_passwordController.text == _confirmPasswordController.text) {
        context.read<RegisterBloc>().add(
              RegisterButtonPressed(
                username: _usernameController.text,
                password: _passwordController.text,
              ),
            );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    _onGoogleLoginButtonPressed() {
      context.read<LoginBloc>().add(GoogleLoginButtonPressed());
    }

    _onFacebookLoginButtonPressed() {
      context.read<LoginBloc>().add(FacebookLoginButtonPressed());
    }

    _onLineLoginButtonPressed() {
      context.read<LoginBloc>().add(LineLoginButtonPressed());
    }

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder()),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                if (state is RegisterLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _onRegisterButtonPressed,
                    child: const Text('REGISTER'),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _onGoogleLoginButtonPressed,
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Google'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _onFacebookLoginButtonPressed,
                      icon: const Icon(Icons.facebook),
                      label: const Text('Facebook'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _onLineLoginButtonPressed,
                      icon: const Icon(Icons.line_axis),
                      label: const Text('Line'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
