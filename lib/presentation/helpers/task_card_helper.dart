import 'package:flutter/material.dart';
import 'package:diego/domain/entities/task.dart';
import 'package:diego/constants/constants.dart';

class TaskCardHelper {
  static const String PASOS_TITULO = 'Pasos';

  static Widget buildTaskCard(
    Task task, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required BuildContext context,
  }) {
    return Dismissible(
      key: Key(task.title),
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (rigth) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$tarea_eliminada',

              style: TextStyle(
                color: Colors.amber[50],
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.pink[900],
            duration: const Duration(seconds: 1),
          ),
        );
      },

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(task.descripcion),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    task.type == 'URGENTE' ? Icons.warning : Icons.task,
                    color: task.type == 'URGENTE' ? Colors.red : Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tipo: ${task.type}',
                    style: TextStyle(
                      color: task.type == 'URGENTE' ? Colors.red : Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    task.fecha.toLocal().toString().split(' ')[0],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              if (task.pasos.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  PASOS_TITULO,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: Text(
                    '• ${task.pasos[0]}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),

                //.toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
