import 'package:diego/constants/constants.dart';
import 'package:diego/data/repositories/noticia_repository.dart';
import 'package:diego/domain/entities/noticia.dart';

class NoticiaService {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();

  // Método para obtener las primeras 10 noticias desde la API
  Future<List<Noticia>> obtenerNoticiasIniciales({
    bool ordenarPorFecha = false,
    bool ordenarPorFuente = false,
  }) async {
    try {
      // Llama al repositorio para obtener las primeras 10 noticias
      final noticias = await _noticiaRepository.fetchInitialNoticias();
      _validarListaNoticias(noticias);

      // Ordenar las noticias si se especifica
      if (ordenarPorFecha) {
        noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl));
      } else if (ordenarPorFuente) {
        noticias.sort((a, b) => a.fuente.compareTo(b.fuente));
      }

      return noticias;
    } catch (e) {
      throw Exception('Error al obtener noticias iniciales: $e');
    }
  }

  // Método para obtener noticias paginadas desde la API
  Future<List<Noticia>> obtenerNoticiasPaginadas(
    int numeroPagina, {
    int tamanoPagina = Constants.pageSize, // Tamaño de página por defecto
    bool ordenarPorFecha = false,
    bool ordenarPorFuente = false,
  }) async {
    if (numeroPagina < 1) {
      throw ArgumentError('El número de página debe ser mayor o igual a 1.');
    }
    if (tamanoPagina <= 0) {
      throw ArgumentError('El tamaño de página debe ser mayor que 0.');
    }

    try {
      // Llama al repositorio para obtener noticias paginadas
      final noticias = await _noticiaRepository.fetchPaginatedNoticias(
        numeroPagina,
        pageSize: tamanoPagina,
      );
      _validarListaNoticias(noticias);

      // Ordenar las noticias si se especifica
      if (ordenarPorFecha) {
        noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl));
      } else if (ordenarPorFuente) {
        noticias.sort((a, b) => a.fuente.compareTo(b.fuente));
      }

      return noticias;
    } catch (e) {
      throw Exception('Error al obtener noticias paginadas: $e');
    }
  }

  // Método para crear una noticia
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      await _noticiaRepository.crearNoticia(noticia);
    } catch (e) {
      throw Exception('Error al crear la noticia: $e');
    }
  }

  // Método privado para validar una lista de noticias
  void _validarListaNoticias(List<Noticia> noticias) {
    for (final noticia in noticias) {
      _validarNoticia(noticia);
    }
  }

  // Método privado para validar una noticia individual
  void _validarNoticia(Noticia noticia) {
    if (noticia.titulo.isEmpty) {
      throw ArgumentError('El título de la noticia no puede estar vacío.');
    }
    if (noticia.descripcion.isEmpty) {
      throw ArgumentError('La descripción de la noticia no puede estar vacía.');
    }
    if (noticia.fuente.isEmpty) {
      throw ArgumentError('La fuente de la noticia no puede estar vacía.');
    }
    if (noticia.publicadaEl.isAfter(DateTime.now())) {
      throw ArgumentError(
        'La fecha de publicación no puede estar en el futuro.',
      );
    }
  }
}
