import 'package:flutter/material.dart';
import 'package:diego/api/service/auth_service.dart';
import 'package:diego/presentation/welcome_screen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final MockAuthService authService = MockAuthService();

    // Clave global para el formulario
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El usuario es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Validar el formulario
                  if (formKey.currentState!.validate()) {
                    final String username = usernameController.text.trim();
                    final String password = passwordController.text.trim();
                    
                    try {
                      // Llama al servicio de autenticación
                      await authService.login(username, password);

                      // Muestra un mensaje de éxito
                      
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                      
                    } catch (e) {
                      // Maneja errores del servicio
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                  
                
              
                
                },
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}