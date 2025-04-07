import 'package:flutter/material.dart';
import 'package:diego/domain/entities/task.dart';
import 'package:diego/constants/constants.dart';
import 'package:diego/api/service/task_service.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TaskService _taskService = TaskService();
  final ScrollController _scrollController = ScrollController();
  List<Task> _tareas = [];

  @override
  void initState() {
    super.initState();
    _cargarTareas();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // TODO: Implement pagination logic here
      _cargarMasTareas();
    }
  }

  Future<void> _cargarTareas() async {
    try {
      final tareas = await _taskService.getTasks();
      setState(() {
        _tareas = tareas;
      });
    } catch (e) {
      _mostrarError('Error al cargar tareas: $e');
    }
  }

  void _cargarMasTareas() {
    // TODO: Implement loading more tasks
  }

  Future<void> _agregarTarea(Task tarea) async {
    try {
      await _taskService.createTask(tarea);
      await _cargarTareas();
    } catch (e) {
      _mostrarError('Error al agregar tarea: $e');
    }
  }

  Future<void> _actualizarTarea(int index, Task tarea) async {
    try {
      await _taskService.updateTask(index, tarea);
      await _cargarTareas();
    } catch (e) {
      _mostrarError('Error al actualizar tarea: $e');
    }
  }

  Future<void> _eliminarTarea(int index) async {
    try {
      await _taskService.deleteTask(index);
      await _cargarTareas();
    } catch (e) {
      _mostrarError('Error al eliminar tarea: $e');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _mostrarModalAgregarTarea({int? index}) async {
    final task = index != null ? await _taskService.getTaskById(index) : null;

    final TextEditingController tituloController = TextEditingController(
      text: task?.title ?? '',
    );
    final TextEditingController detalleController = TextEditingController(
      text: task?.descripcion ?? '',
    );
    final TextEditingController fechaController = TextEditingController(
      text: task?.fecha.toLocal().toString().split(' ')[0] ?? '',
    );
    DateTime? fechaSeleccionada = task?.fecha;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Agregar Tarea' : 'Editar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: detalleController,
                decoration: const InputDecoration(
                  labelText: 'Detalle',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fechaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  hintText: 'Seleccionar Fecha',
                ),
                onTap: () async {
                  DateTime? nuevaFecha = await showDatePicker(
                    context: context,
                    initialDate: fechaSeleccionada ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (nuevaFecha != null) {
                    setState(() {
                      fechaSeleccionada = nuevaFecha;
                      fechaController.text =
                          nuevaFecha.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el modal sin guardar
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final titulo = tituloController.text.trim();
                final detalle = detalleController.text.trim();
                final fecha = fechaController.text.trim();

                if (titulo.isEmpty || detalle.isEmpty || fecha.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todos los campos son obligatorios'),
                    ),
                  );
                  return;
                }

                final tarea = Task(
                  title: titulo,
                  type: detalle,
                  fecha: fechaSeleccionada!,
                  descripcion: detalle,
                );

                if (index == null) {
                  await _agregarTarea(tarea);
                } else {
                  await _actualizarTarea(index, tarea);
                }

                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_APPBAR),
        backgroundColor: Colors.pinkAccent,
      ),
      body:
          _tareas.isEmpty
              ? const Center(child: Text(EMPTY_LIST))
              : ListView.builder(
                controller: _scrollController,
                itemCount: _tareas.length,
                itemBuilder: (context, index) {
                  final task = _tareas[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.descripcion),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Fecha
                            Text(
                              task.fecha.toLocal().toString().split(' ')[0],
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            // Tipo con icono
                            Row(
                              children: [
                                Icon(
                                  task.type == 'urgente'
                                      ? Icons.warning
                                      : Icons.task,
                                  color:
                                      task.type == 'urgente'
                                          ? Colors.red
                                          : Colors.blue,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tipo: ${task.type}',
                                  style: TextStyle(
                                    color:
                                        task.type == 'urgente'
                                            ? Colors.red
                                            : Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed:
                              () => _mostrarModalAgregarTarea(index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _eliminarTarea(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarModalAgregarTarea(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
