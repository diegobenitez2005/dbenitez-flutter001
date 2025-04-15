import 'package:diego/domain/entities/quote.dart';

class QuoteRepository {
  static final List<Quote> quotes = [
    Quote(
      companyName: 'Apple',
      stockPrice: 150.25,
      changePercentage: 2.5,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Microsoft',
      stockPrice: 280.50,
      changePercentage: -1.2,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Google',
      stockPrice: 2750.30,
      changePercentage: 0.8,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Amazon',
      stockPrice: 3450.10,
      changePercentage: -0.5,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Tesla',
      stockPrice: 720.75,
      changePercentage: 3.1,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Sodep',
      stockPrice: 1800.75,
      changePercentage: 2.1,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Ueno',
      stockPrice: 64.75,
      changePercentage: 6.1,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'OpenAI',
      stockPrice: 1060.75,
      changePercentage: 3.1,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Nvidia',
      stockPrice: 3045.75,
      changePercentage: 0.1,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Samsung',
      stockPrice: 120.75,
      changePercentage: 4.1,
      lastUpdated: DateTime.now(),
    ),
  ];

  // Método para obtener todas las cotizaciones
  Future<List<Quote>> fetchAllQuotes() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simula un delay de 2 segundos
    return List.from(quotes); // Devuelve una copia de la lista de cotizaciones
  }

  // Método para obtener una cotización aleatoria
  Future<Quote> fetchRandomQuote() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simula un delay de 2 segundos
    quotes.shuffle();
    return quotes.first; // Devuelve una cotización aleatoria
  }
}
