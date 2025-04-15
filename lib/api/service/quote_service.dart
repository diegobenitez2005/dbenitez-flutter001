import 'package:diego/data/repositories/quote_repository.dart';
import 'package:diego/domain/entities/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  // Método para obtener todas las cotizaciones
  Future<List<Quote>> getAllQuotes() async {
    return await _repository.fetchAllQuotes();
  }

  // Método para obtener una cotización aleatoria
  Future<Quote> getRandomQuote() async {
    return await _repository.fetchRandomQuote();
  }
}
