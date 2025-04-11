import 'package:diego/presentation/helpers/common_widgets_herlpers.dart';
import 'package:flutter/material.dart';
import 'package:diego/domain/entities/task.dart';
import 'package:diego/constants/constants.dart';
import 'package:diego/api/service/task_service.dart';
import 'package:diego/presentation/helpers/task_card_helper.dart';
import 'package:diego/presentation/deportiva_screen.dart';
import 'package:diego/presentation/helpers/helper_constructor_deportiva.dart.dart';
import 'package:diego/presentation/login_screen.dart';
import 'package:diego/presentation/welcome_screen.dart';
import 'package:diego/presentation/contador_screen.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TaskService _taskService = TaskService();
  final ScrollController _scrollController = ScrollController();
  List<Task> _tareas = [];
  int _nextTaskId = 7; // Para simular nuevas tareas
  bool _isLoading = false;
  int taskCounter = 0;

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
      if (!_isLoading) {
        _cargarMasTareas();
      }
    }
  }

  Future<void> _cargarTareas() async {
    try {

      
      final tareas = await _taskService.getTasksWithSteps();
      setState(() {
        _tareas = tareas;
        taskCounter = _tareas.length;
      });
    } catch (e) {
      _mostrarError('Error al cargar tareas: $e');
    }
  }

  Future<void> _cargarMasTareas() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulamos carga de 6 tareas nuevas
    await Future.delayed(const Duration(seconds: 1));

    final nuevasTareas = List.generate(6, (index) {
      final nuevaTarea = Task(
        title: 'Tarea ${_nextTaskId + index}',
        descripcion: 'Descripción de tarea ${_nextTaskId + index}',
        fecha: DateTime.now().add(Duration(days: index)),
        type: index % 2 == 0 ? 'NORMAL' : 'URGENTE',
        deadline: DateTime.now().add(Duration(days: index + 1)),
        pasos: [], // Inicialmente vacío
      );

      // Generar pasos para la nueva tarea
      nuevaTarea.pasos = _taskService.obtenerPasos(
        nuevaTarea.title,
        nuevaTarea.deadline,
      );

      return nuevaTarea;
    });

    setState(() {
      _tareas.addAll(nuevasTareas);
      _nextTaskId += 6;
      _isLoading = false;
    });
    setState(() {
      taskCounter = _tareas.length;
    });
  }

  Future<void> _agregarTarea(Task tarea) async {
    try {
      await _taskService.createTask(tarea);
      setState(() {
        _tareas.add(tarea);
      });
    } catch (e) {
      _mostrarError('Error al agregar tarea: $e');
      await _cargarTareas(); // Recargar solo en caso de error
    }
  }

  Future<void> _actualizarTarea(int index, Task tarea) async {
    try {
      await _taskService.updateTask(index, tarea);
      setState(() {
        _tareas[index] = tarea;
      });
    } catch (e) {
      _mostrarError('Error al actualizar tarea: $e');
      await _cargarTareas(); // Recargar solo en caso de error
    }
  }

  Future<void> _eliminarTarea(int index) async {
    try {
      await _taskService.deleteTask(index);
      setState(() {
        _tareas.removeAt(index);
        taskCounter = _tareas.length;
      });
    } catch (e) {
      _mostrarError('Error al eliminar tarea: $e');
      await _cargarTareas(); // Recargar solo en caso de error
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
    final TextEditingController pasosController = TextEditingController(
      text: task?.pasos.join(', ') ?? '', // Convertir lista de pasos a texto
    );
    DateTime? fechaSeleccionada = task?.fecha;
    final TextEditingController tipoController = TextEditingController(
      text: task?.type ?? '',
    );

    void _seleccionarFecha() async {
      DateTime? nuevaFecha = await showDatePicker(
        context: context,
        initialDate: fechaSeleccionada ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (nuevaFecha != null) {
        setState(() {
          fechaSeleccionada = nuevaFecha;
          fechaController.text = nuevaFecha.toLocal().toString().split(' ')[0];
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Agregar Tarea' : 'Editar Tarea'),
          content: SingleChildScrollView(
            child: Column(
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
                  onTap: () => _seleccionarFecha(),
                ),
                const SizedBox(height: 16),
                // TextField(
                //   controller: pasosController,
                //   decoration: const InputDecoration(
                //     labelText: 'Pasos (separados por comas)',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value:
                      tipoController.text.isEmpty ||
                              tipoController.text == 'normal'
                          ? 'normal'
                          : 'urgente',
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Tarea',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'normal',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Normal'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'urgente',
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Urgente'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        tipoController.text = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(height: 20.0),
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
                final tipo = tipoController.text.toUpperCase().trim();
                final pasos = pasosController.text;

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
                  type: tipo,
                  fecha: fechaSeleccionada!,
                  descripcion: detalle,
                  deadline: fechaSeleccionada!,
                  pasos: _taskService.obtenerPasos(
                    tituloController.text,
                    DateTime.now().add(const Duration(days: 1)),
                  ), // Mantener los pasos
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: CommonWidgetsHelper.buildBoldTitle(
          'Lista de Tareas\nTareas ($taskCounter)', // 'Tareas ($taskCounter)' (Contador de tareas en el título de la AppBar)',
          // Título de la AppBar)',
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: CommonWidgetsHelper.buildDrawer(context),
      body:
          _tareas.isEmpty
              ? const Center(child: Text(listaVacia))
              : ListView.builder(
                controller: _scrollController,
                itemCount: _tareas.length + 1, // +1 para el indicador de carga
                itemBuilder: (context, index) {
                  if (index == _tareas.length) {
                    return _isLoading
                        ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : const SizedBox(
                          height: 8.0,
                        ); // Espacio vacío si no se está cargando más
                  }

                  final task = _tareas[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetalleTarjetaScreen(
                                initialIndex: index,
                                tasks:
                                    _tareas, // Pass the required 'tasks' parameter
                              ),
                        ),
                      );
                    },
                    child: TaskCardHelper.buildTaskCard(
                      task,
                      onEdit: () => _mostrarModalAgregarTarea(index: index),
                      onDelete: () => _eliminarTarea(index),
                      context: context,
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
