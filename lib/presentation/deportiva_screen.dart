import 'package:flutter/material.dart';
import 'package:diego/domain/entities/task.dart';
import 'package:diego/helpers/helper_constructor_deportiva.dart.dart';

class DetalleTarjetaScreen extends StatefulWidget {

  const DetalleTarjetaScreen({
    super.key,
    required this.initialIndex,
    required this.tasks,
  });
  final int initialIndex;
  final List<Task> tasks;

  @override
  DetalleTarjetaScreenState createState() => DetalleTarjetaScreenState();
}

class DetalleTarjetaScreenState extends State<DetalleTarjetaScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Tarea'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TarjetaDeportiva(task: task, index: index).build(context),
          );
        },
        onPageChanged: (index) {
          // Opcional: Actualizar el título del AppBar al cambiar de página
          setState(() {});
        },
      ),
    );
  }
}
