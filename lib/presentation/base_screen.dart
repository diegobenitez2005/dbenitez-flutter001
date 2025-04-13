import 'package:diego/presentation/contador_screen.dart';
import 'package:flutter/material.dart';
import 'package:diego/presentation/tareas_screen.dart';
import 'package:diego/presentation/login_screen.dart';
import 'package:diego/presentation/welcome_screen.dart';

class BaseScreen extends StatelessWidget { // Título de la AppBar

  const BaseScreen({super.key, required this.child, required this.title});
  final Widget child; // Contenido de la pantalla
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.pinkAccent),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.pinkAccent),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Tareas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TareasScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tag_faces_sharp),
              title: const Text('Contador'),
              onTap: () {
                // Acción para la configuración
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContadorScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tag_faces_sharp),
              title: const Text('Contador'),
              onTap: () {
                // Acción para la configuración
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContadorScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text(
                        '¿Estás seguro de que deseas cerrar sesión?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text('Cerrar Sesión'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          
          ],
        ),
      ),
    );
  }
}





