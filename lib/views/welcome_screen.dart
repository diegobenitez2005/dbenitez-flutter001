import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;

  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido/a'),
      ),
      body: Center(
        child: Text(
          'Bienvenido/a, $username!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}