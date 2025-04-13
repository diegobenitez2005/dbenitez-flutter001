import 'package:diego/constants/constants.dart';
import 'package:diego/presentation/contador_screen.dart';
import 'package:diego/presentation/login_screen.dart';
import 'package:diego/presentation/tareas_screen.dart';
import 'package:diego/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';

class CommonWidgetsHelper {
  /// Construye un título en negrita con tamaño 20.
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  /// Muestra hasta 3 líneas de información.
  /// La primera línea es obligatoria, las otras son opcionales.
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line1, style: const TextStyle(fontSize: 16)),
        if (line2 != null)
          Text(line2, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        if (line3 != null)
          Text(line3, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  /// Construye un pie de página en negrita.
  static Widget buildBoldFooter(String footer) {
    return Text(
      '$fecha_limite $footer',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  /// Construye un SizedBox con altura de 8.
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  /// Devuelve un borde redondeado con un radio de 10.
  static RoundedRectangleBorder buildRoundedBorder() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  }

  static Widget buildDrawer(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.pinkAccent),
            child: Text(
              'Menú de Navegación',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.push(
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
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Salir'),
            onTap: () {
              // Cierra la aplicación
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text('¿Estás seguro de que deseas salir?'),
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
                          ); // Redirige al login
                        },
                        child: const Text('Salir'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget buildNavBar(index, onTap) {
    return BottomNavigationBar(
      backgroundColor: Colors.pinkAccent,
      currentIndex: index, // Índice del elemento seleccionado
      selectedItemColor: Colors.white, // Color de los labels seleccionados
      unselectedItemColor: Colors.white,
      onTap: onTap, // Maneja el evento de selección
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.tag_faces, color: Colors.white),
          label: "Contador",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Colors.white),
          label: 'Añadir Tarea',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.close, color: Colors.white),
          label: "Salir",
        ),
      ],
    );
  }
}
