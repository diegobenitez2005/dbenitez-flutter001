import 'dart:async';

class MockAuthService {
  Future<void> login(String username, String password) async {
    // Simula un retraso para imitar una llamada a un servicio real
    await Future.delayed(Duration(seconds: 1));
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('El usuario y la contraseña no pueden estar vacíos.');
    }

    // Imprime las credenciales en la consola
    print('Mock Login:');
    print('Username: $username');
    print('Password: $password');

    // Simula una respuesta exitosa
    return;
  }
}
