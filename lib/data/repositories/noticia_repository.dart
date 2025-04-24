import 'package:diego/constants/constants.dart';
import 'package:diego/domain/entities/noticia.dart';
import 'package:dio/dio.dart';

class NoticiaRepository {
  final Dio _dio = Dio();

  // Método para obtener las primeras 10 noticias desde la API
  Future<Map<String, dynamic>> fetchInitialNoticias() async {
    try {
      final url = Constants.newUrl;
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return {
          'statusCode': response.statusCode,
          'data': data.map((json) => Noticia.fromJson(json)).toList(),
          'message': 'Noticias cargadas con éxito',
        };
      } else if (response.statusCode == 404) {
        return {
          'statusCode': response.statusCode,
          'data': <Noticia>[],
          'message': 'No se encontraron noticias',
        };
      } else if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 500) {
        final errorMessage = response.data['message'] ?? 'Error de validación';
        return {
          'statusCode': response.statusCode,
          'data': <Noticia>[],
          'message': errorMessage,
        };
      } else if (response.statusCode != null && response.statusCode! >= 500) {
        return {
          'statusCode': response.statusCode,
          'data': <Noticia>[],
          'message': 'Error en el servidor',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'data': <Noticia>[],
          'message': 'Error desconocido',
        };
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Tiempo de espera agotado para la conexión';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión a internet';
      } else {
        errorMessage = 'Error al obtener noticias: ${e.message}';
      }
      return {
        'statusCode': e.response?.statusCode,
        'data': <Noticia>[],
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'statusCode': -1,
        'data': <Noticia>[],
        'message': 'Error al obtener noticias iniciales: $e',
      };
    }
  }

  // Método para obtener noticias paginadas desde la API
  Future<Map<String, dynamic>> fetchPaginatedNoticias(
    int pageNumber, {
    int pageSize = Constants.pageSize,
  }) async {
    try {
      final url = Constants.newUrl;
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return {
          'statusCode': response.statusCode,
          'data': data.map((json) => Noticia.fromJson(json)).toList(),
          'message': 'Noticias cargadas con éxito',
        };
      } else if (response.statusCode == 404) {
        return {
          'statusCode': response.statusCode,
          'data': <Noticia>[],
          'message': 'No se encontraron noticias',
        };
      } else if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 500) {
        final errorMessage = response.data['message'] ?? 'Error de validación';
        return {
          'statusCode': response.statusCode,
          'data': <Noticia>[],
          'message': errorMessage,
        };
      } else if (response.statusCode != null && response.statusCode! >= 500) {
        return {
          'statusCode': response.statusCode,
          'data': <Noticia>[],
          'message': 'Error en el servidor',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'data': <Noticia>[],
          'message': 'Error desconocido',
        };
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Tiempo de espera agotado para la conexión';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión a internet';
      } else {
        errorMessage = 'Error al obtener noticias: ${e.message}';
      }
      return {
        'statusCode': e.response?.statusCode,
        'data': <Noticia>[],
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'statusCode': -1,
        'data': <Noticia>[],
        'message': 'Error al obtener noticias paginadas: $e',
      };
    }
  }

  Future<Map<String, dynamic>> crearNoticia(Noticia noticia) async {
    try {
      final url = Constants.newUrl;
      final noticiaJson = {
        'titulo': noticia.titulo,
        'descripcion': noticia.descripcion,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.urlImagen,
      };

      final response = await _dio.post(url, data: noticiaJson);

      if (response.statusCode == 201) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': 'Noticia creada con éxito',
        };
      } else if (response.statusCode == 400) {
        final errorMessage = response.data['message'] ?? 'Error de validación';
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': errorMessage,
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'No autorizado para crear noticias',
        };
      } else if (response.statusCode == 500) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Error interno del servidor',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Error al publicar la noticia',
        };
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Tiempo de espera agotado para la conexión';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión a internet';
      } else {
        errorMessage = 'Error al crear la noticia: ${e.message}';
      }
      return {
        'statusCode': e.response?.statusCode,
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'statusCode': -1,
        'success': false,
        'message': 'Error al publicar la noticia: $e',
      };
    }
  }

  Future<Map<String, dynamic>> actualizarNoticia(
    String id,
    Noticia noticia,
  ) async {
    try {
      final url = '${Constants.newUrl}/$id'; // URL para actualización con el ID
      final noticiaJson = {
        'titulo': noticia.titulo,
        'descripcion': noticia.descripcion,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.urlImagen,
      };

      final response = await _dio.put(url, data: noticiaJson);

      if (response.statusCode == 200) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': 'Noticia actualizada con éxito',
        };
      } else if (response.statusCode == 400) {
        final errorMessage = response.data['message'] ?? 'Error de validación';
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': errorMessage,
        };
      } else if (response.statusCode == 404) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Noticia no encontrada',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'No autorizado para actualizar noticias',
        };
      } else if (response.statusCode == 500) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Error interno del servidor',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Error al actualizar la noticia',
        };
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Tiempo de espera agotado para la conexión';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión a internet';
      } else {
        errorMessage = 'Error al actualizar la noticia: ${e.message}';
      }
      return {
        'statusCode': e.response?.statusCode,
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'statusCode': -1,
        'success': false,
        'message': 'Error al actualizar la noticia: $e',
      };
    }
  }

  Future<Map<String, dynamic>> eliminarNoticia(String id) async {
    try {
      final url = '${Constants.newUrl}/$id'; // URL para eliminación con el ID
      final response = await _dio.delete(url);

      if (response.statusCode == 200) {
        return {
          'statusCode': response.statusCode,
          'success': true,
          'message': 'Noticia eliminada con éxito',
        };
      } else if (response.statusCode == 404) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Noticia no encontrada',
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'No autorizado para eliminar noticia',
        };
      } else if (response.statusCode == 500) {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Error interno del servidor',
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'success': false,
          'message': 'Error al eliminar la noticia',
        };
      }
    } on DioException catch (e) {
      String errorMessage;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Tiempo de espera agotado para la conexión';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión a internet';
      } else {
        errorMessage = 'Error al eliminar la noticia: ${e.message}';
      }
      return {
        'statusCode': e.response?.statusCode,
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'statusCode': -1,
        'success': false,
        'message': 'Error al eliminar la noticia: $e',
      };
    }
  }
}
