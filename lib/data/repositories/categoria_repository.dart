import 'package:diego/constants/constants.dart';
import 'package:diego/domain/entities/categoria.dart';
import 'package:dio/dio.dart';
import 'package:diego/exceptions/api_exceptions.dart';

class CategoriaRepository {

  CategoriaRepository() : _dio = Dio() {
    // Configurar tiempo máximo de espera para todas las peticiones
    _dio.options.connectTimeout =  Duration(milliseconds: Constants.timeOutSeconds * 1000);
    _dio.options.receiveTimeout =  Duration(milliseconds: Constants.timeOutSeconds * 1000);
    
  }
  final Dio _dio;

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _dio.get(Constants.urlCategorias);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Error al obtener las categorías',
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
        'Error al conectar con la API de categorías: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      final response = await _dio.post(
        Constants.urlCategorias,
        data: categoria,
      );

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la categoría',
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
        'Error al conectar con la API de categorías: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(
    String id,
    Map<String, dynamic> categoria,
  ) async {
    try {
      final url = '${Constants.urlCategorias}/$id';
      final response = await _dio.put(url, data: categoria);

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la categoría',
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
        'Error al conectar con la API de categorías: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${Constants.urlCategorias}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la categoría',
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
        'Error al conectar con la API de categorías: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }
}
