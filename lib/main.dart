import 'package:diego/presentation/tareas_screen.dart';
import 'package:diego/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:diego/presentation/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 77, 77),
        ),
      ),
      home: const LoginScreen(), // Cambia a TareasScreen para mostrar la lista de tareas
    );
  }
}

