
import 'package:diego/constants/constants.dart';
import 'package:diego/domain/entities/noticia.dart';
import 'package:dio/dio.dart';

class NoticiaRepository {
  final Dio _dio = Dio();

  // Método para obtener las primeras 10 noticias desde la API
  Future<List<Noticia>> fetchInitialNoticias() async {
    try {
      // Construye la URL con los parámetros directamente
      final url = Constants.newUrl;

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error en la respuesta de la API: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener las noticias iniciales: $e');
    }
  }

  // Método para obtener noticias paginadas desde la API
  Future<List<Noticia>> fetchPaginatedNoticias(
    int pageNumber, {
    int pageSize = Constants.pageSize,
  }) async {
    try {
      // Construye la URL con los parámetros directamente
      final url = Constants.newUrl;
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error en la respuesta de la API: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener noticias paginadas: $e');
    }
  }

  Future<void> crearNoticia(Noticia noticia) async {
    try {
      // Construye la URL base
      final url = Constants.newUrl;

      // Convierte la noticia al formato JSON
      final noticiaJson = {
        'titulo': noticia.titulo,
        'descripcion': noticia.descripcion,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.urlImagen,
      };

      // Realiza la solicitud POST
      final response = await _dio.post(url, data: noticiaJson);

      if (response.statusCode == 201) {
       
      } else {
        throw Exception('Error al publicar la noticia: ${response.statusCode}');
      }
    } catch (e) {
      ;
      throw Exception('Error al publicar la noticia: $e');
    }
  }
}
