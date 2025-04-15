import 'package:diego/constants/constants.dart';
import 'package:diego/data/repositories/quote_repository.dart';
import 'package:diego/domain/entities/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  // Método para obtener todas las cotizaciones predefinidas
  Future<List<Quote>> fetchAllQuotes() async {
    final quotes = await _repository.fetchPredefinedQuotes();
    _validateQuotes(quotes);
    return quotes;
  }

  // Método para generar cotizaciones aleatorias
  Future<List<Quote>> fetchRandomQuotes(int count) async {
    final quotes = await _repository.generateRandomQuotes(count);
    _validateQuotes(quotes);
    _ordenarCotizacionesPorPrecio(quotes);
    return quotes;
  }

  // Método para obtener cotizaciones paginadas con validaciones
  Future<List<Quote>> getPaginatedQuotes(
    int pageNumber, {
    int pageSize = Constants.pageSize,
  }) async {
    // Validaciones
    if (pageNumber < 1) {
      throw Exception('El número de página debe ser mayor o igual a 1');
    }
    if (pageSize <= 0) {
      throw Exception('El tamaño de página debe ser mayor que 0');
    }

    // Llama al repositorio para obtener las cotizaciones paginadas
    final quotes = await _repository.fetchPaginatedQuotes(
      pageNumber,
      pageSize: pageSize,
    );

    _validateQuotes(quotes);
    _ordenarCotizacionesPorPrecio(quotes);
    return quotes;
  }

  // Método privado para validar las cotizaciones
  void _validateQuotes(List<Quote> quotes) {
    for (final quote in quotes) {
      if (quote.stockPrice < 0) {
        throw Exception(
          'Error: La cotización de ${quote.companyName} tiene un stockPrice negativo (${quote.stockPrice}).',
        );
      }
    }
    for (final quote in quotes) {
      if (quote.changePercentage < -100 || quote.changePercentage > 100) {
        throw Exception(
          'Error: La cotización de ${quote.companyName} tiene un changePercentage fuera de rango (${quote.changePercentage}).',
        );
      }
    }
  }

  void _ordenarCotizacionesPorPrecio(List<Quote> quotes) {
    Quote aux;
    for (int i = 0; i < quotes.length; i++) {
      for (int j = i + 1; j < quotes.length; j++) {
        if (quotes[i].stockPrice > quotes[j].stockPrice) {
          aux = quotes[i];
          quotes[i] = quotes[j];
          quotes[j] = aux;
        }
      }
    }
  }
}
