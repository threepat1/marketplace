import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/presentation/profile_form/bloc/profile_completion_bloc.dart';

class ProfileCompletionPage extends StatelessWidget {
  final User user;
  const ProfileCompletionPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Provide the BLoC to the widget tree.
    return BlocProvider(
      create: (context) => ProfileCompletionBloc(),
      child: ProfileCompletionForm(user: user),
    );
  }
}

class ProfileCompletionForm extends StatefulWidget {
  final User user;
  const ProfileCompletionForm({super.key, required this.user});

  @override
  State<ProfileCompletionForm> createState() => _ProfileCompletionFormState();
}

class _ProfileCompletionFormState extends State<ProfileCompletionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _birthdayController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _surnameController = TextEditingController(text: widget.user.surname);
    _emailController = TextEditingController(text: widget.user.email);
    _birthdayController = TextEditingController(text: widget.user.birthday);
    _genderController = TextEditingController(text: widget.user.gender);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Dispatch the event to the BLoC with all form data.
      context.read<ProfileCompletionBloc>().add(
            ProfileSubmitted(
              user: widget.user,
              newName: _nameController.text,
              newSurname: _surnameController.text,
              newEmail: _emailController.text,
              newBirthday: _birthdayController.text,
              newGender: _genderController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: BlocListener<ProfileCompletionBloc, ProfileCompletionState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate away from the form.
            Navigator.of(context).pop();
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Please provide a few more details to complete your profile.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(labelText: 'Surname'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(labelText: 'Birthday'),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ProfileCompletionBloc, ProfileCompletionState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit Profile'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
