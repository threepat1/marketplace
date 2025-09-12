import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/presentation/profile_form/bloc/profile_completion_bloc.dart';
import 'package:marketplace/presentation/login/bloc/login_bloc.dart';

class ProfileCompletionPage extends StatelessWidget {
  final User user;
  const ProfileCompletionPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
  late TextEditingController _birthYearController;
  late TextEditingController _birthMonthController;
  late TextEditingController _birthDayController;
  late TextEditingController _genderController;

  // Define a dynamic year range for the dropdown.
  final earliestYear = DateTime.now().year - 100;
  final latestYear = DateTime.now().year - 10;

  // Generate lists for years, months, and genders.
  late final List<String> years = List<String>.generate(
    latestYear - earliestYear + 1,
    (i) => (latestYear - i).toString(),
  );

  final List<String> months =
      List<String>.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));

  // Note: We'll generate days based on the selected month/year in the UI.
  final List<String> genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _surnameController = TextEditingController(text: widget.user.surname);
    _emailController = TextEditingController(text: widget.user.email);
    _genderController = TextEditingController(text: widget.user.gender);

    // Safely split the birthday string to avoid the LateInitializationError.
    final List<String>? userBirthdayParts = widget.user.birthday?.split('-');

    if (userBirthdayParts != null && userBirthdayParts.length == 3) {
      // If the birthday string is valid, use its parts to initialize the controllers.
      _birthYearController = TextEditingController(text: userBirthdayParts[0]);
      _birthMonthController = TextEditingController(text: userBirthdayParts[1]);
      _birthDayController = TextEditingController(text: userBirthdayParts[2]);
    } else {
      // If the birthday string is null or invalid, initialize with empty controllers.
      _birthYearController = TextEditingController();
      _birthMonthController = TextEditingController();
      _birthDayController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _birthYearController.dispose();
    _birthMonthController.dispose();
    _birthDayController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Concatenate the separate date parts into a single string.
      final newBirthday =
          '${_birthYearController.text}-${_birthMonthController.text}-${_birthDayController.text}';

      context.read<ProfileCompletionBloc>().add(
            ProfileSubmitted(
              user: widget.user,
              newName: _nameController.text,
              newSurname: _surnameController.text,
              newEmail: _emailController.text,
              newBirthday: newBirthday,
              newGender: _genderController.text,
            ),
          );
    }
  }

  bool isLoginSuccess = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<ProfileCompletionBloc, ProfileCompletionState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<LoginBloc>().add(ProfileSubmittedCompleted());
            Navigator.of(context).pop(true);
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
                const Text(
                  'Birthday',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Year Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _birthYearController.text.isNotEmpty
                            ? _birthYearController.text
                            : null,
                        decoration: const InputDecoration(labelText: 'Year'),
                        items: years.map((String year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _birthYearController.text = newValue ?? '';
                            // Reset day and month to force re-selection based on new year.
                            _birthMonthController.text = '';
                            _birthDayController.text = '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Month Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _birthMonthController.text.isNotEmpty
                            ? _birthMonthController.text
                            : null,
                        decoration: const InputDecoration(labelText: 'Month'),
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _birthMonthController.text = newValue ?? '';
                            _birthDayController.text = ''; // Reset day
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Day Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _birthDayController.text.isNotEmpty
                            ? _birthDayController.text
                            : null,
                        decoration: const InputDecoration(labelText: 'Day'),
                        items: getDaysForMonth(
                                int.tryParse(_birthYearController.text),
                                int.tryParse(_birthMonthController.text))
                            .map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _birthDayController.text = newValue ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _genderController.text.isNotEmpty
                      ? _genderController.text
                      : null,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _genderController.text = newValue ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
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

// Helper function to get the number of days in a month.
  List<String> getDaysForMonth(int? year, int? month) {
    if (year == null || month == null) {
      return [];
    }
    final int daysInMonth;
    final bool isLeapYear =
        (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
    if (month == 2) {
      daysInMonth = isLeapYear ? 29 : 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      daysInMonth = 30;
    } else {
      daysInMonth = 31;
    }
    return List<String>.generate(
        daysInMonth, (i) => (i + 1).toString().padLeft(2, '0'));
  }
}
