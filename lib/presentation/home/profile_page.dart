import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/presentation/authentication/bloc/authentication_bloc.dart';

class ProfilePage extends StatelessWidget {
  // 1. CHANGE THE INPUT from a String to the User entity
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle,
                size: 120, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(
              // 2. ACCESS THE NAME from the user object
              'Welcome, ${user.name}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('LOGOUT'),
              onPressed: () {
                context.read<AuthenticationBloc>().add(LoggedOut());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
