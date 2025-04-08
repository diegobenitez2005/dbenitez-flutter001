import 'package:flutter/material.dart';
import 'package:diego/domain/entities/task.dart';
import 'package:diego/api/service/task_service.dart';

class TaskCardHelper {
  static const String PASOS_TITULO = 'Pasos';

  static Widget buildTaskCard(
    Task task, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("${task.title} eliminada")),
        // );
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
 Widget construirTarjetaDeportiva (Task task, int index, {
  required VoidCallback onEdit,
  required VoidCallback onDelete,
 }) {
     
  
  return Card(
    shape: RoundedRectangleBorder(
    
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 8,
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen aleatoria
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
          child: Image.network(
            'https://picsum.photos/200/300?random=$index',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Pasos (máximo 3 líneas)
              if (task.pasos.isNotEmpty) ...[
                Text(
                  'Pasos:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                ...task.pasos.take(3).map((paso) => Text(
                      '• $paso',
                      style: const TextStyle(fontSize: 12),
                    )),
              ],
              const SizedBox(height: 8),
              // Fecha límite
              Text(
                'Fecha límite: ${task.fechaLimite.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(color: Colors.grey),
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
        ),
      ],
    ),
  );
}
