import 'package:diego/constants/constants.dart';
class Task {
  final String title;
  final String type;
  final String descripcion;
  DateTime fecha;
    Task({required this.title, this.type = TASK_TYPE_NORMAL, required this.descripcion, required this.fecha});
}
