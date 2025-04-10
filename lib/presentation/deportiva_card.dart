// import 'package:flutter/material.dart';
// import 'package:diego/domain/entities/task.dart';

// class TarjetaDeportiva {
//   Widget construirTarjetaDeportiva(Task task, int index) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//       elevation: 8,
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20.0),
//               topRight: Radius.circular(20.0),
//             ),
//             child: Image.network(
//               'https://picsum.photos/200/300?random=$index',
//               width: double.infinity,
//               height: 350,
//               fit: BoxFit.cover, // Asegura que la imagen cubra el contenedor
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start, // Cambiado a center
//               children: [
//                 // Título
//                 Text(
//                   task.title,
//                   style: const TextStyle(
//                     fontSize: 34,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center, // Centrar el texto
//                 ),
//                 const SizedBox(height: 8),
//                 // Pasos (máximo 3 líneas)
//                 if (task.pasos.isNotEmpty) ...[
//                   Text(
//                     'Pasos:',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24,
//                     ),
//                     textAlign: TextAlign.center, // Centrar el texto
//                   ),
//                   ...task.pasos
//                       .take(3)
//                       .map(
//                         (paso) => Text(
//                           '• $paso',
//                           style: const TextStyle(fontSize: 18),
//                           textAlign: TextAlign.center, // Centrar el texto
//                         ),
//                       ),
//                 ],
//                 const SizedBox(height: 8),
//                 // Fecha límite
//                 Text(
//                   'Fecha límite: ${task.fechaLimite.toLocal().toString().split(' ')[0]}',
//                   style: const TextStyle(color: Colors.lightBlueAccent,
//                    fontSize: 24),
//                   textAlign: TextAlign.center, // Centrar el texto

//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:diego/domain/entities/task.dart';

class TarjetaDeportiva extends StatelessWidget {
  final Task task;
  final int index;

  const TarjetaDeportiva({required this.task, required this.index});

  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(30.0),
      color: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sección de imagen con bordes redondeados en la parte superior
          SizedBox(height: 20),
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
                // Título de la tarea
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Pasos de la tarea (máximo 3)
                if (task.pasos.isNotEmpty) ...[
                  Text(
                    'Pasos:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ...task.pasos
                      .take(3)
                      .map(
                        (paso) => Text(
                          '$paso',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                ],

                const SizedBox(height: 8),

                // Fecha límite
                Text(
                  'Fecha límite: ${task.deadline.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
