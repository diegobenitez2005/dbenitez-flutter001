import 'package:flutter/material.dart';
import 'package:diego/api/service/quote_service.dart';
import 'package:diego/domain/entities/quote.dart';
import 'package:diego/constants/constants.dart';
import 'package:intl/intl.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final ScrollController _scrollController = ScrollController();

  final List<Quote> _quotes = [];
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadQuotes() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newQuotes = await _quoteService.getPaginatedQuotes(
        _currentPage,
        pageSize: Constants.pageSize,
      );

      setState(() {
        _quotes.addAll(newQuotes);
        _currentPage++;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar cotizaciones: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadQuotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(Constants.titleQuotes),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _quotes.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  controller: _scrollController,
                  itemCount: _quotes.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _quotes.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final quote = _quotes[index];

                    const double sizedHeitght = 10.0;
                    return Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              quote.companyName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Precio: \$${quote.stockPrice.toStringAsFixed(2)}',
                                ),
                                Text(
                                  'Cambio: ${quote.changePercentage.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color:
                                        quote.changePercentage >= 0
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                                Text(
                                  'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm').format(quote.lastUpdated)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: sizedHeitght),
                      ],
                    );
                  },
                ),
      ),
    );
  }
}
