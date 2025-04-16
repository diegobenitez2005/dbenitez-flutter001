import 'package:diego/constants/constants.dart';
import 'package:diego/data/repositories/noticia_repository.dart';
import 'package:diego/domain/entities/noticia.dart';

class NoticiaService {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();

  // Método para obtener noticias predefinidas
  Future<List<Noticia>> obtenerNoticiasPredefinidas() async {
    final noticias = await _noticiaRepository.fetchPredefinedNoticias();
    _validarListaNoticias(noticias);
    return noticias;
  }

  

  // Método para obtener noticias paginadas
  Future<List<Noticia>> obtenerNoticiasPaginadas(
    int numeroPagina, {
    int tamanoPagina = Constants.pageSize, // Tamaño de página por defecto
  }) async {
    if (numeroPagina < 1) {
      throw ArgumentError('El número de página debe ser mayor o igual a 1.');
    }
    if (tamanoPagina <= 0) {
      throw ArgumentError('El tamaño de página debe ser mayor que 0.');
    }

    final noticias = await _noticiaRepository.fetchPaginatedNoticias(
      numeroPagina,
      pageSize: tamanoPagina,
    );
    _validarListaNoticias(noticias);
    return noticias;
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
