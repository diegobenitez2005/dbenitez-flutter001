import 'package:diego/presentation/contador_screen.dart';
import 'package:flutter/material.dart';
import 'package:diego/presentation/tareas_screen.dart';
import 'package:diego/presentation/login_screen.dart';
import 'package:diego/presentation/welcome_screen.dart';

class BaseScreen extends StatelessWidget {
  final Widget child; // Contenido de la pantalla
  final String title; // Título de la AppBar

  const BaseScreen({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.pinkAccent),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pinkAccent),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tareas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TareasScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.tag_faces_sharp),
              title: Text('Contador'),
              onTap: () {
                // Acción para la configuración
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContadorScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.tag_faces_sharp),
              title: Text('Contador'),
              onTap: () {
                // Acción para la configuración
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContadorScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar Sesión'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirmar'),
                      content: Text(
                        '¿Estás seguro de que deseas cerrar sesión?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text('Cerrar Sesión'),
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





