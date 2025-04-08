import 'package:diego/domain/entities/task.dart';
import 'package:flutter/foundation.dart';

class TaskRepository {
  static final List<Task> initialTasks = [
    Task(
      title: 'Tarea 1',
      type: 'URGENTE',
      descripcion: 'Descripción de la tarea 1',
      fecha: DateTime(2024, 4, 14),
      fechaLimite: DateTime(2024, 4, 8).add(const Duration(days: 1)),
      pasos: obtenerPasos('Tarea 1', DateTime(2024, 4, 8).add(const Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 2',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 2',
      fecha: DateTime(2024, 4, 19),
      fechaLimite: DateTime(2024, 4, 8).add(const Duration(days: 3)),
      pasos: obtenerPasos('Tarea 2', DateTime(2024, 4, 8).add(const Duration(days: 3))),
    ),
    Task(
      title: 'Tarea 3',
      type: 'URGENTE',
      descripcion: 'Descripción de la tarea 3',
      fecha: DateTime(2024, 4, 21),
      fechaLimite: DateTime(2024, 4, 8).add(const Duration(days: 4)),
      pasos: obtenerPasos('Tarea 3', DateTime(2024, 4, 8).add(const Duration(days: 4))),
    ),
    Task(
      title: 'Tarea 4',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 4',
      fecha: DateTime(2024, 4, 10),
      fechaLimite: DateTime(2024, 4, 8).add(const Duration(days: 5)),
      pasos: obtenerPasos('Tarea 4', DateTime(2024, 4, 8).add(const Duration(days: 5))),
    ),
    Task(
      title: 'Tarea 5',
      type: 'URGENTE',
      descripcion: 'Descripción de la tarea 5',
      fecha: DateTime(2024, 4, 16),
      fechaLimite: DateTime(2024, 4, 8).add(const Duration(days: 6)),
      pasos: obtenerPasos('Tarea 5', DateTime(2024, 4, 8).add(const Duration(days: 6))),
    ),
    Task(
      title: 'Tarea 6',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 6',
      fecha: DateTime(2024, 4, 17),
      fechaLimite: DateTime(2024, 4, 8).add(const Duration(days: 7)),
      pasos: obtenerPasos('Tarea 6', DateTime(2024, 4, 8).add(const Duration(days: 7))),
    ),
    Task(
      title: 'Tarea 7',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 6',
      fecha: DateTime(2024, 4, 17),
      fechaLimite: DateTime(2024, 4, 8).add(const Duration(days: 7)),
      pasos: obtenerPasos('Tarea 7', DateTime(2024, 4, 8).add(const Duration(days: 7))),
    ),
    Task(
      title: 'Tarea 8',
      type: 'NORMAL',
      descripcion: 'Descripción de la tarea 6',
      fecha: DateTime(2024, 4, 17),
      fechaLimite: DateTime(2024, 4, 8).add(const Duration(days: 7)),
      pasos: obtenerPasos('Tarea 8', DateTime(2024, 4, 8).add(const Duration(days: 7))),
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
    final List<String> pasos = obtenerPasos(task.title, task.fechaLimite);

    // Crear nueva tarea con los pasos
    final nuevaTarea = Task(
      title: task.title,
      type: task.type,
      descripcion: task.descripcion,
      fecha: task.fecha,
      pasos: pasos, // Usar los pasos generados
      fechaLimite: task.fechaLimite,
    );

    _tasks.add(nuevaTarea);
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

  static List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    final fechaStr = fechaLimite.toLocal().toString().split(' ')[0];

    return [
      'Paso 1: Planificar $titulo  $fechaStr',
      'Paso 2: Ejecutar $titulo  $fechaStr',
      'Paso 3: Revisar $titulo  $fechaStr',
    
    ];
  }
}
