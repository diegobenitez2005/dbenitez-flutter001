import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido/a')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido/a, el login fue exitoso',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20), // Espaciado entre el texto y el botón
            ElevatedButton(
              onPressed: () {
                // Mostrar el diálogo con la lista de cotizaciones
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Lista de Cotizaciones'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          children: const [
                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text('Cotización 1: \$100'),
                            ),
                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text('Cotización 2: \$200'),
                            ),
                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text('Cotización 3: \$300'),
                            ),
                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text('Cotización 4: \$400'),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Ver Cotizaciones'),
            ),
          ],
        ),
      ),
    );
  }
}
