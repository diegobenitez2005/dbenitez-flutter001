import 'package:diego/constants/constants.dart';

class Task {
  Task({
    required this.title,
    this.type = Constants.taskTypeNormal,
    required this.descripcion,
    required this.fecha,
    this.pasos = Constants.listaPasoVacia,
    required this.deadline,
  });
  final String title;
  final String type;
  final String descripcion;
  List<String> pasos;
  DateTime fecha;
  DateTime deadline;
}
