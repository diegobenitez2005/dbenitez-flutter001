
class Noticia {

  Noticia({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.urlImagen,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['_id'] ?? "Sin ID",
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      fuente: json['fuente'] ?? 'Fuente desconocida',
      publicadaEl: DateTime.parse(json['publicadaEl']),
      urlImagen: json['urlImagen'] ?? 'Sin imagen',
    );
  }
  final String? id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen;
}