import 'package:diego/api/service/categoria_service.dart';
import 'package:diego/constants/constants.dart';
import 'package:diego/domain/entities/categoria.dart';
import 'package:diego/exceptions/api_exceptions.dart';

class CategoriaRepository {
  final CategoriaService _categoriaService = CategoriaService();

  /// Obtiene todas las categorías desde el repositorio
  Future<List<Categoria>> getCategorias() async {
    try {
      return await _categoriaService.getCategorias();
    } catch (e) {
      if (e is ApiException) {
        // Verificar si es un error de timeout específicamente
        if (e.statusCode == 408) {
          throw Exception(Constants.messageErrorTimeout);
        }
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Crea una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      await _categoriaService.crearCategoria(categoria.toJson());
    } catch (e) {
      if (e is ApiException) {
        // Verificar si es un error de timeout específicamente
        if (e.statusCode == 408) {
          throw Exception(Constants.messageErrorTimeout);
        }
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Edita una categoría existente
  Future<void> editarCategoria(String? id, Categoria categoria) async {
    try {
      if (id == null) {
        throw Exception('El ID no puede ser nulo');
      }
      await _categoriaService.editarCategoria(id, categoria.toJson());
    } catch (e) {
      if (e is ApiException) {
        // Verificar si es un error de timeout específicamente
        if (e.statusCode == 408) {
          throw Exception(Constants.messageErrorTimeout);
        }
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String? id) async {
    try {
      // Validar que el ID no sea nulo
      if (id == null || id.isEmpty) {
        throw Exception('El ID de la categoría no puede ser nulo o vacío');
      }

      await _categoriaService.eliminarCategoria(id);
    } catch (e) {
      if (e is ApiException) {
        // Verificar si es un error de timeout específicamente
        if (e.statusCode == 408) {
          throw Exception(Constants.messageErrorTimeout);
        }
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
}
