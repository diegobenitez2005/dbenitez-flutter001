import 'package:diego/constants/constants.dart';

class Task {
  final String title;
  final String type;
  final String descripcion;
  List<String> pasos;
  DateTime fecha;
  DateTime deadline;
  Task({
    required this.title,
    this.type = taskTypeNormal,
    required this.descripcion,
    required this.fecha,
    this.pasos = listaPasosVacia,
    required this.deadline,
  });
}
