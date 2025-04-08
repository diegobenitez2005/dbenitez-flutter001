class ServiciosTareas {
  // Singleton pattern
  static final ServiciosTareas _instance = ServiciosTareas._internal();
  factory ServiciosTareas() => _instance;
  ServiciosTareas._internal();

  Future<List<String>> obtenerPasos(String tituloTarea) async {
    // Simula delay de consulta a IA
    await Future.delayed(const Duration(milliseconds: 500));

    // Simula respuesta según título
    final numero = int.tryParse(tituloTarea.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    
    switch (numero % 3) {
      case 0:
        return ['Planificar', 'Organizar', 'Validar'];
      case 1:
        return ['Ejecutar', 'Implementar', 'Probar'];
      case 2:
        return ['Revisar', 'Ajustar', 'Finalizar'];
      default:
        return ['Analizar', 'Desarrollar', 'Verificar'];
    }
  }
}