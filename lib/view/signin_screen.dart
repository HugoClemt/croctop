import 'package:croctop/services/authentification_service.dart';
import 'package:croctop/view/home_screen.dart';
import 'package:croctop/view/signup_screen.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthentificationService _authService = AuthentificationService();
  String? _message;

  void _signin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await _authService.signin(email, password);

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
        title: const Text('Signin'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: const Text('Sign Up')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_message != null) Text(_message!),
            ElevatedButton(
              onPressed: _signin,
              child: const Text('Signin'),
            ),
          ],
        ),
      ),
    );
  }
}
