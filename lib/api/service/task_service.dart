import 'package:diego/domain/entities/task.dart';
import 'package:diego/data/repositories/task_repository.dart';
import 'package:diego/data/repositories/assistant_repository.dart';

class TaskService {
  // Singleton pattern
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  // Repository instance
  final TaskRepository _repository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository();

  // Create
  Future<Task> createTask(Task task) async {
    try {
      _repository.addTask(task);
      return task;
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  // Read
  Future<List<Task>> getTasks() async {
    List<Task> listaTareas = _repository.getTasks();
    try {
      for (int i = 0; i < listaTareas.length; i++) {
        listaTareas[i].pasos = obtenerPasos(
          listaTareas[i].title,
          listaTareas[i].fechaLimite,
        );
      }
    } catch (e) {
      listaTareas = [];
      throw Exception('Error getting tasks: $e');
    }
    return listaTareas;
  }

  Future<Task?> getTaskById(int index) async {
    try {
      return _repository.getTaskById(index);
    } catch (e) {
      throw Exception('Error getting task: $e');
    }
  }

  // Update
  Future<bool> updateTask(int index, Task task) async {
    try {
      return _repository.updateTask(index, task);
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  // Delete
  Future<bool> deleteTask(int index) async {
    try {
      return _repository.deleteTask(index);
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    {
      //var titulo = 'Tarea 1';
      //var fechaLimite = DateTime(2024, 4, 8).add(const Duration(days: 1));
      try {
        return _assistantRepository.obtenerPasos(titulo, fechaLimite);
      } catch (e) {
        throw Exception('Error getting steps: $e');
      }
    }

    //   static List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    //     final fechaStr = fechaLimite.toLocal().toString().split(' ')[0];

    //     return [
    //       'Paso 1: Planificar $titulo antes de $fechaStr',
    //       'Paso 2: Ejecutar $titulo antes de $fechaStr',
    //       'Paso 3: Revisar $titulo antes de $fechaStr',

    //     ];
    //   }
  }
}
