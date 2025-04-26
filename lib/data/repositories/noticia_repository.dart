import 'package:diego/api/service/noticia_service.dart';
import 'package:diego/constants/constants.dart';
import 'package:diego/domain/entities/noticia.dart';
import 'package:diego/exceptions/api_exceptions.dart';
import 'package:diego/helpers/error_helper.dart';
import 'package:flutter/material.dart';

class NoticiaRepository {
  final NoticiaService _noticiaService = NoticiaService();
  String _lastErrorMessage = '';
  int? _lastStatusCode;
  bool _hasError = false;

  // Getters para información de error
  String get lastErrorMessage => _lastErrorMessage;
  int? get lastStatusCode => _lastStatusCode;
  bool get hasError => _hasError;

  // Método para obtener el mensaje de error y color según el código de estado
  Map<String, dynamic> getErrorInfo() {
    return ErrorHelper.getErrorMessageAndColor(_lastStatusCode);
  }

  // Método para obtener las primeras noticias desde la API
  Future<List<Noticia>> obtenerNoticiasIniciales() async {
    // Reiniciar estado de error
    _clearError();

    try {
      final noticias = await _noticiaService.fetchInitialNoticias();

      // Ordenar según los parámetros

      return noticias;
    } on ApiException catch (e) {
      // Verificar si es un error de timeout específicamente
      if (e.statusCode == 408) {
        _setError(Constants.messageErrorTimeout, e.statusCode);
      } else {
        _setError(e.message, e.statusCode);
      }
      return [];
    } catch (e) {
      _setError('Error inesperado: $e', null);
      return [];
    }
  }

  // Método para obtener noticias paginadas desde la API
  Future<List<Noticia>> obtenerNoticiasPaginadas(
    int numeroPagina, {
    int tamanoPagina = Constants.pageSize,
  }) async {
    // Reiniciar estado de error
    _clearError();

    // Validar parámetros
    if (numeroPagina < 1) {
      _setError('El número de página debe ser mayor o igual a 1.', 400);
      return [];
    }

    if (tamanoPagina <= 0) {
      _setError('El tamaño de página debe ser mayor que 0.', 400);
      return [];
    }

    try {
      final noticias = await _noticiaService.fetchPaginatedNoticias(
        numeroPagina,
        pageSize: tamanoPagina,
      );

      return noticias;
    } on ApiException catch (e) {
      // Verificar si es un error de timeout específicamente
      if (e.statusCode == 408) {
        _setError(Constants.messageErrorTimeout, e.statusCode);
      } else {
        _setError(e.message, e.statusCode);
      }
      return [];
    } catch (e) {
      _setError('Error inesperado: $e', null);
      return [];
    }
  }

  // Método para crear una noticia
  Future<bool> crearNoticia(Noticia noticia) async {
    // Reiniciar estado de error
    _clearError();

    try {
      // Validar datos de la noticia
      _validarNoticia(noticia);

      // Llamar al repositorio para crear la noticia
      await _noticiaService.crearNoticia(noticia);
      return true;
    } on ApiException catch (e) {
      // Verificar si es un error de timeout específicamente
      if (e.statusCode == 408) {
        _setError(Constants.messageErrorTimeout, e.statusCode);
      } else {
        _setError(e.message, e.statusCode);
      }
      return false;
    } catch (e) {
      _setError('Error inesperado: $e', null);
      return false;
    }
  }

  // Método para actualizar una noticia existente
  Future<bool> actualizarNoticia(Noticia noticia) async {
    // Reiniciar estado de error
    _clearError();

    // Validar que la noticia tenga ID
    if (noticia.id == null || noticia.id!.isEmpty) {
      _setError('No se puede actualizar una noticia sin ID', 400);
      return false;
    }

    try {
      // Validar datos de la noticia
      _validarNoticia(noticia);

      // Llamar al repositorio para actualizar la noticia
      await _noticiaService.actualizarNoticia(noticia.id!, noticia);
      return true;
    } on ApiException catch (e) {
      // Verificar si es un error de timeout específicamente
      if (e.statusCode == 408) {
        _setError(Constants.messageErrorTimeout, e.statusCode);
      } else {
        _setError(e.message, e.statusCode);
      }
      return false;
    } catch (e) {
      _setError('Error inesperado: $e', null);
      return false;
    }
  }

  // Método para eliminar una noticia
  Future<bool> eliminarNoticia(String id) async {
    // Reiniciar estado de error
    _clearError();

    // Validar que tengamos un ID
    if (id.isEmpty) {
      _setError('No se puede eliminar una noticia sin ID', 400);
      return false;
    }

    try {
      // Llamar al repositorio para eliminar la noticia
      await _noticiaService.eliminarNoticia(id);
      return true;
    } on ApiException catch (e) {
      // Verificar si es un error de timeout específicamente
      if (e.statusCode == 408) {
        _setError(Constants.messageErrorTimeout, e.statusCode);
      } else {
        _setError(e.message, e.statusCode);
      }
      return false;
    } catch (e) {
      _setError('Error inesperado: $e', null);
      return false;
    }
  }

  // Método privado para validar una noticia
  void _validarNoticia(Noticia noticia) {
    if (noticia.titulo.isEmpty) {
      throw ApiException(
        'El título de la noticia no puede estar vacío.',
        statusCode: 400,
      );
    }
    if (noticia.descripcion.isEmpty) {
      throw ApiException(
        'La descripción de la noticia no puede estar vacía.',
        statusCode: 400,
      );
    }
    if (noticia.fuente.isEmpty) {
      throw ApiException(
        'La fuente de la noticia no puede estar vacía.',
        statusCode: 400,
      );
    }
    if (noticia.publicadaEl.isAfter(DateTime.now())) {
      throw ApiException(
        'La fecha de publicación no puede estar en el futuro.',
        statusCode: 400,
      );
    }
  }

  // Método para establecer un error
  void _setError(String message, int? statusCode) {
    _hasError = true;
    _lastErrorMessage = message;
    _lastStatusCode = statusCode;
    debugPrint('Error: $message (Código: $statusCode)');
  }

  // Método para limpiar el estado de error
  void _clearError() {
    _hasError = false;
    _lastErrorMessage = '';
    _lastStatusCode = null;
  }
}
