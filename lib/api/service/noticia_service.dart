import 'package:diego/constants/constants.dart';
import 'package:diego/data/repositories/noticia_repository.dart';
import 'package:diego/domain/entities/noticia.dart';
import 'package:flutter/material.dart';

class NoticiaService {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();
  String _lastErrorMessage = '';
  int? _lastStatusCode;
  bool _hasError = false;

  // Getters para información de error
  String get lastErrorMessage => _lastErrorMessage;
  int? get lastStatusCode => _lastStatusCode;
  bool get hasError => _hasError;

  // Método para obtener las primeras 10 noticias desde la API
  Future<List<Noticia>> obtenerNoticiasIniciales({
    bool ordenarPorFecha = false,
    bool ordenarPorFuente = false,
  }) async {
    // Reiniciar estado de error
    _clearError();

    final response = await _noticiaRepository.fetchInitialNoticias();
    final int statusCode = response['statusCode'] ?? -1;
    final String message = response['message'] ?? 'Error desconocido';
    final List<Noticia> noticias = response['data'] ?? [];

    // Verificar si hay error basado en el statusCode
    if (statusCode < 200 || statusCode >= 300) {
      _setError(message, statusCode);
      return [];
    }

    // Validar noticias (podría lanzar excepciones)
    try {
      _validarListaNoticias(noticias);
    } catch (e) {
      _setError('Error de validación: $e', 422);
      return [];
    }

    // Ordenar noticias si es necesario
    

    return noticias;
  }

  // Método para obtener noticias paginadas desde la API
  Future<List<Noticia>> obtenerNoticiasPaginadas(
    int numeroPagina, {
    int tamanoPagina = Constants.pageSize,
    
  }) async {
    // Validar parámetros
    if (numeroPagina < 1) {
      _setError('El número de página debe ser mayor o igual a 1.', 400);
      return [];
    }
    if (tamanoPagina <= 0) {
      _setError('El tamaño de página debe ser mayor que 0.', 400);
      return [];
    }

    // Reiniciar estado de error
    _clearError();

    final response = await _noticiaRepository.fetchPaginatedNoticias(
      numeroPagina,
      pageSize: tamanoPagina,
    );
    final int statusCode = response['statusCode'] ?? -1;
    final String message = response['message'] ?? 'Error desconocido';
    final List<Noticia> noticias = response['data'] ?? [];

    // Verificar si hay error basado en el statusCode
    if (statusCode < 200 || statusCode >= 300) {
      _setError(message, statusCode);
      return [];
    }

    // Validar noticias (podría lanzar excepciones)
    try {
      _validarListaNoticias(noticias);
    } catch (e) {
      _setError('Error de validación: $e', 422);
      return [];
    }


    return noticias;
  }

  // Método para crear una noticia
  Future<bool> crearNoticia(Noticia noticia) async {
    // Reiniciar estado de error
    _clearError();

    try {
      _validarNoticia(noticia);
    } catch (e) {
      _setError('Error de validación: $e', 422);
      return false;
    }

    final response = await _noticiaRepository.crearNoticia(noticia);
    final int statusCode = response['statusCode'] ?? -1;
    final String message = response['message'] ?? 'Error desconocido';
    final bool success = response['success'] ?? false;

    if (!success) {
      _setError(message, statusCode);
      return false;
    }

    return true;
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

  // Método para establecer un error
  void _setError(String message, int? statusCode) {
    _hasError = true;
    _lastErrorMessage = message;
    _lastStatusCode = statusCode;
    debugPrint('Error: $message ($statusCode)');
  }

  // Método para limpiar el estado de error
  void _clearError() {
    _hasError = false;
    _lastErrorMessage = '';
    _lastStatusCode = null;
  }
  // Añadir este método a la clase NoticiaService
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
    } catch (e) {
      _setError('Error de validación: $e', 422);
      return false;
    }

    // Llamar al repositorio para actualizar la noticia
    final response = await _noticiaRepository.actualizarNoticia(noticia.id!, noticia);
    final int statusCode = response['statusCode'] ?? -1;
    final String message = response['message'] ?? 'Error desconocido';
    final bool success = response['success'] ?? false;

    if (!success) {
      _setError(message, statusCode);
      return false;
    }

    return true;
  }
  // Añadir este método a la clase NoticiaService
  Future<bool> eliminarNoticia(String id) async {
    // Reiniciar estado de error
    _clearError();

    // Validar que tengamos un ID
    if (id.isEmpty) {
      _setError('No se puede eliminar una noticia sin ID', 400);
      return false;
    } 

    // Llamar al repositorio para eliminar la noticia
    final response = await _noticiaRepository.eliminarNoticia(id);
    final int statusCode = response['statusCode'] ?? -1;
    final String message = response['message'] ?? 'Error desconocido';
    final bool success = response['success'] ?? false;

    if (!success) {
      _setError(message, statusCode);
      return false;
    }

    return true;
  }
}
