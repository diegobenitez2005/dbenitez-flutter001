import 'package:diego/constants/constants.dart';
import 'package:flutter/material.dart';

class CommonWidgetsHelper {
  /// Construye un título en negrita con tamaño 20.
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  /// Muestra hasta 3 líneas de información.
  /// La primera línea es obligatoria, las otras son opcionales.
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line1, style: const TextStyle(fontSize: 16)),
        if (line2 != null)
          Text(line2, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        if (line3 != null)
          Text(line3, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  /// Construye un pie de página en negrita.
  static Widget buildBoldFooter(String footer) {
    return Text(
      '$fechaLimite $footer',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  /// Construye un SizedBox con altura de 8.
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  /// Devuelve un borde redondeado con un radio de 10.
  static RoundedRectangleBorder buildRoundedBorder() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  }
}
