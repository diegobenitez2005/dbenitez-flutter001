import 'package:diego/domain/entities/task.dart';
import 'package:diego/api/service/task_service.dart';

final TaskService _taskService = TaskService();

class TaskRepository {
  static final List<Task> initialTasks = [
    Task(
      title: 'Tarea 1',
      type: 'URGENTE',
      descripcion: 'Descripción de la tarea 1',
      fecha: DateTime(2024, 4, 10),
      deadline: DateTime(2024, 4, 10).add(const Duration(days: 1)),
    ),
    Task(
      title: 'Tarea 2',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 2',
      fecha: DateTime(2024, 4, 11),
      deadline: DateTime(2024, 4, 10).add(const Duration(days: 3)),
    ),
    Task(
      title: 'Tarea 3',
      type: 'URGENTE',
      descripcion: 'Descripción de la tarea 3',
      fecha: DateTime(2024, 4, 12),
      deadline: DateTime(2024, 4, 10).add(const Duration(days: 4)),
    ),
    Task(
      title: 'Tarea 4',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 4',
      fecha: DateTime(2024, 4, 13),
      deadline: DateTime(2024, 4, 10).add(const Duration(days: 5)),
    ),
    Task(
      title: 'Tarea 5',
      type: 'URGENTE',
      descripcion: 'Descripción de la tarea 5',
      fecha: DateTime(2024, 4, 14),
      deadline: DateTime(2024, 4, 10).add(const Duration(days: 6)),
    ),
    Task(
      title: 'Tarea 6',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 6',
      fecha: DateTime(2024, 4, 15),
      deadline: DateTime(2024, 4, 10).add(const Duration(days: 7)),
    ),
    Task(
      title: 'Tarea 7',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 6',
      fecha: DateTime(2024, 4, 16),
      deadline: DateTime(2024, 4, 10).add(const Duration(days: 7)),
    ),
    Task(
      title: 'Tarea 8',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 6',
      fecha: DateTime(2024, 4, 17),
      deadline: DateTime(2024, 4, 10).add(const Duration(days: 8)),
    ),
  ];

  List<Task> _tasks = List.from(initialTasks);

  // Getters
  List<Task> getTasks() => List.from(_tasks);

  Task? getTaskById(int index) {
    if (index >= 0 && index < _tasks.length) {
      return _tasks[index];
    }
    return null;
  }

  // Setters
  void addTask(Task task) {
    // Obtener pasos usando la función existente
    //final List<String> pasos = _taskService.obtenerPasos(task.title, task.fechaLimite);

    // Crear nueva tarea con los pasos
    final nuevaTarea = Task(
      title: task.title,
      type: task.type,
      descripcion: task.descripcion,
      fecha: task.fecha, // Usar los pasos generados
      deadline: task.deadline,
      pasos: task.pasos,
    );

    _tasks.add(nuevaTarea);
  }

  bool updateTask(int index, Task task) {
    //final List<String> pasos = _taskService.obtenerPasos(task.title, task.fechaLimite);

    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = task;
      return true;
    }
    return false;
  }

  bool deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      return true;
    }
    return false;
  }

  void resetTasks() {
    _tasks = List.from(initialTasks);
  }
}
