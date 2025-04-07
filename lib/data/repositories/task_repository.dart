import 'package:diego/domain/entities/task.dart';

class TaskRepository {
  static final List<Task> initialTasks = [
    Task(
      title: 'Tarea 1',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 1',
      fecha: DateTime(2024, 4, 7),
    ),
    Task(
      title: 'Tarea 2',
      type: 'normal',
      descripcion: 'Descripción de la tarea 2',
      fecha: DateTime(2024, 4, 8),
    ),
    Task(
      title: 'Tarea 3',
      type: 'normal',
      descripcion: 'Descripción de la tarea 3',
      fecha: DateTime(2024, 4, 9),
    ),
    Task(
      title: 'Tarea 4',
      type: 'normal',
      descripcion: 'Descripción de la tarea 4',
      fecha: DateTime(2024, 4, 10),
    ),
    Task(
      title: 'Tarea 5',
      type: 'urgente',
      descripcion: 'Descripción de la tarea 5',
      fecha: DateTime(2024, 4, 11),
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
    _tasks.add(task);
  }

  bool updateTask(int index, Task task) {
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
