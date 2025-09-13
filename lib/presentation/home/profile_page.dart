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
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.settings),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.shopping_cart),
                )
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.account_circle,
                    size: 40, color: Colors.blueAccent),
                const SizedBox(width: 20),
                Text(
                  // 2. ACCESS THE NAME from the user object
                  '${user.name}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
