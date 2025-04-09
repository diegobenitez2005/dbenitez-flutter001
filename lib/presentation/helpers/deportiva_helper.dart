import 'package:flutter/material.dart';
import 'package:diego/domain/entities/task.dart';
import 'package:diego/presentation/deportiva_card.dart';

class DetalleTarjetaScreen extends StatelessWidget {
  final Task task;
  final int index;
  final List<Task> tasks; // Lista completa de tareas

  const DetalleTarjetaScreen({
    Key? key,
    required this.task,
    required this.index,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tarjetaDeportiva = TarjetaDeportiva(task: task, index: index);

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        backgroundColor: Colors.pinkAccent,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            // Deslizar hacia la izquierda (siguiente tarea)
            final siguienteIndice = (index + 1) % tasks.length;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DetalleTarjetaScreen(
                      task: tasks[siguienteIndice],
                      index: siguienteIndice,
                      tasks: tasks,
                    ),
              ),
            );
          } else if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            // Deslizar hacia la derecha (tarea anterior)
            final anteriorIndice =
                (index - 1 + tasks.length) % tasks.length; // Manejo cíclico
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DetalleTarjetaScreen(
                      task: tasks[anteriorIndice],
                      index: anteriorIndice,
                      tasks: tasks,
                    ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: tarjetaDeportiva.build(context),
        ),
      ),
    );
  }
}
