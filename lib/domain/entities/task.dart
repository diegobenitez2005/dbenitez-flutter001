import 'package:diego/constants/constants.dart';

class Task {
  final String title;
  final String type;
  final String descripcion;
  List<String> pasos;
  DateTime fecha;
  DateTime fechaLimite;
  Task({
    required this.title,
    this.type = TASK_TYPE_NORMAL,
    required this.descripcion,
    required this.fecha,
    this.pasos = LISTA_PASOS_VACIA,
    DateTime? fechaLimite
   
  }):fechaLimite = fechaLimite ?? DateTime.now().add( const Duration(days:7));
}
