import 'package:diego/helpers/common_widgets_herlpers.dart';
import 'package:flutter/material.dart';
import 'package:diego/domain/entities/task.dart';

class TarjetaDeportiva extends StatelessWidget {

  const TarjetaDeportiva({super.key, required this.task, required this.index});
  final Task task;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(30.0),
      color: Colors.white,
      elevation: 8.0,
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sección de imagen con bordes redondeados en la parte superior
          CommonWidgetsHelper.buildSpacing(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Image.network(
                'https://picsum.photos/200/300?random=$index',
                width: 300,
                height: 300,
                fit: BoxFit.cover, // Asegura que la imagen cubra el contenedor
              ),
            ),
          ),
          // Sección de contenido
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(task.title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,

                ),), // Título de la tarea
                // Título de la tarea
                CommonWidgetsHelper.buildSpacing(),

                // Pasos de la tarea (máximo 3)
                if (task.pasos.isNotEmpty) ...[
                  const Text(
                    'Pasos:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ...task.pasos
                      .take(3)
                      .map(
                        (paso) => CommonWidgetsHelper.buildInfoLines(
                          paso,
                        ),
                      ),
                ],

                CommonWidgetsHelper.buildSpacing(),

                // Fecha límite
                CommonWidgetsHelper.buildBoldFooter(task.deadline.toString().split(' ')[0]),
                CommonWidgetsHelper.buildSpacing(),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
