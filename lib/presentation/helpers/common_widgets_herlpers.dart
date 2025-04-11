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
      style: TextStyle(
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
      '$fechaLimite $footer',
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
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.pinkAccent),
            child: Text(
              'Menú de Navegación',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.push(
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
            leading: Icon(Icons.exit_to_app),
            title: Text('Salir'),
            onTap: () {
              // Cierra la aplicación
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirmar'),
                    content: Text('¿Estás seguro de que deseas salir?'),
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
                          ); // Redirige al login
                        },
                        child: Text('Salir'),
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
        BottomNavigationBarItem(icon: Icon(Icons.tag_faces,color: Colors.white), 
        label: "Contador",),
        BottomNavigationBarItem(icon: Icon(Icons.add,color: Colors.white), 
        label: 'Añadir Tarea',),
        BottomNavigationBarItem(icon: Icon(Icons.close,color: Colors.white), 
        label: "Salir"),
        
      ],
    );
  }
}
