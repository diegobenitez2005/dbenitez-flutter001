import 'package:diego/constants/constants.dart';

class Noticia {
  Noticia({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.urlImagen,
    required this.categoriaId,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['_id'] ?? "Sin ID",
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      fuente: json['fuente'] ?? 'Fuente desconocida',
      publicadaEl: DateTime.parse(json['publicadaEl']),
      urlImagen: json['urlImagen'] ?? 'Sin imagen',
      categoriaId: json['categoria'] ?? Constants.defaultCategoriaId, // ID de la categoría (opcional, para operaciones CRUD)
    );
  }
  final String? id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen;
  final String? categoriaId; // ID de la categoría (opcional, para operaciones CRUD)

  // Método para obtener la categoría con valor por defecto
  

  // Método para convertir a JSON (útil para crear/actualizar noticias)
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl.toIso8601String(),
      'urlImagen': urlImagen,
      'categoria': categoriaId, // ID de la categoría (opcional, para operaciones CRUD)
    };
  }
}
