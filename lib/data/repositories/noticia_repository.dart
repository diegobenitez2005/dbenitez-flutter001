import 'dart:math';
import 'package:diego/constants/constants.dart';
import 'package:diego/domain/entities/noticia.dart';

class NoticiaRepository {
  final List<Noticia> _noticias = [
    Noticia(
      titulo: 'Noticia 1',
      descripcion: 'Descripción de la noticia 1.',
      fuente: 'Fuente 1',
      publicadaEl: DateTime.now(),
    ),
    Noticia(
      titulo: 'Noticia 2',
      descripcion: 'Descripción de la noticia 2.',
      fuente: 'Fuente 2',
      publicadaEl: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Noticia(
      titulo: 'Noticia 3',
      descripcion: 'Descripción de la noticia 3.',
      fuente: 'Fuente 3',
      publicadaEl: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Noticia(
      titulo: 'Noticia 4',
      descripcion: 'Descripción de la noticia 4.',
      fuente: 'Fuente 4',
      publicadaEl: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Noticia(
      titulo: 'Noticia 5',
      descripcion: 'Descripción de la noticia 5.',
      fuente: 'Fuente 5',
      publicadaEl: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Noticia(
      titulo: 'Noticia 6',
      descripcion: 'Descripción de la noticia 6.',
      fuente: 'Fuente 6',
      publicadaEl: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Noticia(
      titulo: 'Noticia 7',
      descripcion: 'Descripción de la noticia 7.',
      fuente: 'Fuente 7',
      publicadaEl: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Noticia(
      titulo: 'Noticia 8',
      descripcion: 'Descripción de la noticia 8.',
      fuente: 'Fuente 8',
      publicadaEl: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Noticia(
      titulo: 'Noticia 9',
      descripcion: 'Descripción de la noticia 9.',
      fuente: 'Fuente 9',
      publicadaEl: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Noticia(
      titulo: 'Noticia 10',
      descripcion: 'Descripción de la noticia 10.',
      fuente: 'Fuente 10',
      publicadaEl: DateTime.now().subtract(const Duration(days: 9)),
    ),
    Noticia(
      titulo: 'Noticia 11',
      descripcion: 'Descripción de la noticia 11.',
      fuente: 'Fuente 11',
      publicadaEl: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Noticia(
      titulo: 'Noticia 12',
      descripcion: 'Descripción de la noticia 12.',
      fuente: 'Fuente 12',
      publicadaEl: DateTime.now().subtract(const Duration(days: 11)),
    ),
    Noticia(
      titulo: 'Noticia 13',
      descripcion: 'Descripción de la noticia 13.',
      fuente: 'Fuente 13',
      publicadaEl: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Noticia(
      titulo: 'Noticia 14',
      descripcion: 'Descripción de la noticia 14.',
      fuente: 'Fuente 14',
      publicadaEl: DateTime.now().subtract(const Duration(days: 13)),
    ),
    Noticia(
      titulo: 'Noticia 15',
      descripcion: 'Descripción de la noticia 15.',
      fuente: 'Fuente 15',
      publicadaEl: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  final Random _random = Random();

  // Método para obtener noticias predefinidas
  Future<List<Noticia>> fetchPredefinedNoticias() async {
    // Simula un delay de 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    return List.from(_noticias);
  }

  // Método para generar noticias aleatorias
  Future<List<Noticia>> generateRandomNoticias(int count) async {
    // Simula un delay de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    return List.generate(count, (_) {
      final fuentes = [
        'Fuente 1',
        'Fuente 2',
        'Fuente 3',
        'Fuente 4',
        'Fuente 5',
        'Fuente 6',
        'Fuente 7',
        'Fuente 8',
        'Fuente 9',
        'Fuente 10',
      ];

      return Noticia(
        titulo: 'Noticia Aleatoria ${_noticias.length + 1}',
        descripcion: 'Descripción generada aleatoriamente.',
        fuente: fuentes[_random.nextInt(fuentes.length)],
        publicadaEl: DateTime.now().subtract(
          Duration(days: _random.nextInt(30), 
          hours: _random.nextInt(24), 
          minutes: _random.nextInt(60)
          ),
        ),
      );
    });
  }

  // Método para obtener noticias paginadas
  Future<List<Noticia>> fetchPaginatedNoticias(
    int pageNumber, {
    int pageSize = Constants.pageSize, // Tamaño de página por defecto
  }) async {
    // Simula un delay de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    // Genera nuevas noticias si no hay suficientes
    while (_noticias.length < pageNumber * pageSize) {
      _noticias.addAll(await generateRandomNoticias(pageSize));
    }

    // Calcula los índices para la paginación
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Devuelve las noticias correspondientes a la página solicitada
    return _noticias.sublist(
      startIndex,
      endIndex > _noticias.length ? _noticias.length : endIndex,
    );
  }
}
