import 'package:croctop/services/authentification_service.dart';
import 'package:croctop/view/home_screen.dart';
import 'package:croctop/view/signin_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final AuthentificationService _authService = AuthentificationService();
  String? _message;

  void _signup() async {
    final firstname = _firstnameController.text;
    final lastname = _lastnameController.text;
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final birthday = DateTime.parse(_birthdayController.text);

    final response = await _authService.signup(
      firstname,
      lastname,
      username,
      email,
      password,
      birthday,
    );

    if (response.success) {
      if (response.token != null) {
        await _authService.saveToken(response.token!);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _message = response.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SigninScreen()),
              );
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _firstnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _birthdayController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Birthday',
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? birthday = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (birthday != null) {
                  _birthdayController.text = birthday.toIso8601String();
                }
              },
            ),
            ElevatedButton(
              onPressed: _signup,
              child: const Text('Sign Up'),
            ),
            if (_message != null) Text(_message!),
          ],
        ),
      ),
    );
  }
}
