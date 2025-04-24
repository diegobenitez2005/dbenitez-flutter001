import 'package:flutter/material.dart';
import 'package:diego/presentation/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() {
  dotenv.load(fileName: ".env"); // Carga las variables de entorno desde el archivo .env
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

