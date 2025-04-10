
class AssistantRepository {
  List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    final fechaStr = fechaLimite.toLocal().toString().split(' ')[0];
    return [
      'Paso 1: Planificar $titulo antes de $fechaStr ',
      'Paso 2: Ejecutar $titulo antes de $fechaStr ',
      'Paso 3: Revisar $titulo antes de $fechaStr ',
    ];
  }
}












