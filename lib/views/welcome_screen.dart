import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido/a'),
      ),
      body: Center(
        child: Text(
          'Bienvenido/a, el login fue exitoso',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}