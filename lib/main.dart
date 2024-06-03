import 'package:croctop/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CrocTop());
}

class CrocTop extends StatelessWidget {
  const CrocTop({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
