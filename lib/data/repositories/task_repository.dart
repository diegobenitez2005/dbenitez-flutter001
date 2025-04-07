import 'package:diego/domain/entities/task.dart';

class TaskConstants {
  static final List<Task> initialTasks = [
    Task(title: 'tarea 1', type: 'urgente'),
    Task(title: 'tarea 2'),
    Task(title: 'tarea 3'),
    Task(title: 'tarea 4'),
    Task(title: 'tarea 5', type: 'urgente'),
  ];
  List<Task> getTasks() {
    return initialTasks;
  }
}

