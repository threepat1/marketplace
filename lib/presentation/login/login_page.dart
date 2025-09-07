import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/login/bloc/login_bloc.dart';
import 'package:marketplace/presentation/profile_form/profile_form.dart';
import 'package:marketplace/presentation/register/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login to Bid')),
      body: const LoginForm(),
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
    _onGoogleLoginButtonPressed() {
      context.read<LoginBloc>().add(GoogleLoginButtonPressed());
    }

    _onFacebookLoginButtonPressed() {
      context.read<LoginBloc>().add(FacebookLoginButtonPressed());
    }

    _onLineLoginButtonPressed() {
      context.read<LoginBloc>().add(LineLoginButtonPressed());
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

        // New logic: Check for LoginSuccess to show the form.
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ProfileCompletionPage(user: state.user),
            ),
          );
        }

        // New logic: Check for LoginCompleted to navigate directly to the app.
        if (state is LoginCompleted) {
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _onGoogleLoginButtonPressed,
                      icon: const Icon(Icons.gamepad),
                      label: const Text('Log in with Google'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _onFacebookLoginButtonPressed,
                      icon: const Icon(Icons.facebook),
                      label: const Text('Log in with Facebook'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _onLineLoginButtonPressed,
                      icon: const Icon(Icons.line_style),
                      label: const Text('Log in with Line'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
