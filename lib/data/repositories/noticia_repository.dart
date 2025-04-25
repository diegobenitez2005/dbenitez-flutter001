import 'package:diego/constants/constants.dart';
import 'package:diego/domain/entities/noticia.dart';
import 'package:diego/exceptions/api_exceptions.dart';
import 'package:dio/dio.dart';

class NoticiaRepository {
  NoticiaRepository() : _dio = Dio() {
    // Configurar tiempo máximo de espera para todas las peticiones
    _dio.options.connectTimeout = Duration(
      milliseconds: Constants.timeOutSeconds * 1000,
    );
    _dio.options.receiveTimeout = Duration(
      milliseconds: Constants.timeOutSeconds * 1000,
    );
  }

  final Dio _dio;

  /// Obtiene las noticias iniciales desde la API
  Future<List<Noticia>> fetchInitialNoticias() async {
    try {
      final url = Constants.urlNoticias;
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Error al obtener las noticias iniciales',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ApiException(
          'Tiempo de espera agotado',
          statusCode: 408, // Código HTTP para Request Timeout
        );
      }
      throw ApiException(
        'Error al conectar con la API de noticias: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Obtiene noticias paginadas desde la API
  Future<List<Noticia>> fetchPaginatedNoticias(
    int pageNumber, {
    int pageSize = Constants.pageSize,
  }) async {
    try {
      final url = Constants.urlNoticias;
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Error al obtener las noticias paginadas',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException(
        'Error al conectar con la API de noticias: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Crea una nueva noticia
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      final url = Constants.urlNoticias;
      final noticiaJson = {
        'titulo': noticia.titulo,
        'descripcion': noticia.descripcion,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.urlImagen,
      };

      final response = await _dio.post(url, data: noticiaJson);

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          'Error al crear la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException(
        'Error al conectar con la API de noticias: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Actualiza una noticia existente
  Future<void> actualizarNoticia(String id, Noticia noticia) async {
    try {
      final url = '${Constants.urlNoticias}/$id';
      final noticiaJson = {
        'titulo': noticia.titulo,
        'descripcion': noticia.descripcion,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.urlImagen,
      };

      final response = await _dio.put(url, data: noticiaJson);

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al actualizar la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException(
        'Error al conectar con la API de noticias: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Elimina una noticia por su ID
  Future<void> eliminarNoticia(String id) async {
    try {
      final url = '${Constants.urlNoticias}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException(
        'Error al conectar con la API de noticias: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }
}
