import 'package:croctop/services/authentification_service.dart';
import 'package:croctop/view/signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthentificationService _authService = AuthentificationService();

  void _signout() async {
    await _authService.signout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signout,
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to CrocTop!'),
      ),
    );
  }
}
