import 'dart:math';
import 'package:diego/domain/entities/quote.dart';
import 'package:diego/constants/constants.dart';

class QuoteRepository {
  static final List<Quote> predefinedQuotes = [
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
    // Nuevos Quotes Predefinidos
    Quote(
      companyName: 'Meta',
      stockPrice: 320.45,
      changePercentage: 1.5,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Netflix',
      stockPrice: 450.30,
      changePercentage: -0.8,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Nvidia',
      stockPrice: 500.75,
      changePercentage: 4.2,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Samsung',
      stockPrice: 120.50,
      changePercentage: 0.5,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Intel',
      stockPrice: 60.25,
      changePercentage: -1.0,
      lastUpdated: DateTime.now(),
    ),
  ];

  final Random _random = Random();

  // Método para obtener cotizaciones predefinidas
  Future<List<Quote>> fetchPredefinedQuotes() async {
    // Simula un delay de 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    return List.from(predefinedQuotes);
  }

  // Método para generar cotizaciones aleatorias
  Future<List<Quote>> generateRandomQuotes(int count) async {
    // Simula un delay de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    return List.generate(count, (_) {
      final companyNames = [
        'Toyota',
        'Ueno',
        'Sodep',
        'Lactolanda',
        'Huawei',
        'Sony',
        'Oracle',
        'OpenAI',
        'AMD',
        'Ubisoft',
      ];

      return Quote(
        companyName: companyNames[_random.nextInt(companyNames.length)],
        stockPrice:
            _random.nextDouble() * 5000, // Precio aleatorio entre 0 y 5000
        changePercentage:
            _random.nextDouble() * 10 - 5, // Cambio entre -5% y 5%
        lastUpdated: DateTime.now(),
      );
    });
  }

  // Método para obtener cotizaciones paginadas
  Future<List<Quote>> fetchPaginatedQuotes(
    int pageNumber, {
    int pageSize = Constants.pageSize,
  }) async {
    // Simula un delay de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    // Genera nuevas cotizaciones si no hay suficientes
    while (predefinedQuotes.length < pageNumber * pageSize) {
      predefinedQuotes.addAll(await generateRandomQuotes(pageSize));
    }

    // Filtra las cotizaciones con stockPrice positivo
    final filteredQuotes =
        predefinedQuotes.where((quote) => quote.stockPrice > 0).toList();

    // Calcula los índices para la paginación
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Devuelve las cotizaciones correspondientes a la página solicitada
    return filteredQuotes.sublist(
      startIndex,
      endIndex > filteredQuotes.length ? filteredQuotes.length : endIndex,
    );
  }
}
