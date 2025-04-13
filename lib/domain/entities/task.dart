import 'package:diego/constants/constants.dart';

class Task {
  Task({
    required this.title,
    this.type = task_type_normal,
    required this.descripcion,
    required this.fecha,
    this.pasos = lista_pasos_vacia,
    required this.deadline,
  });
  final String title;
  final String type;
  final String descripcion;
  List<String> pasos;
  DateTime fecha;
  DateTime deadline;
}
