import 'package:diego/constants/constants.dart';
import 'package:diego/helpers/common_widgets_herlpers.dart';
import 'package:flutter/material.dart';
import 'package:diego/api/service/noticia_service.dart';
import 'package:diego/domain/entities/noticia.dart';
import 'package:intl/intl.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  State<NoticiaScreen> createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _noticiaService = NoticiaService();
  final ScrollController _scrollController = ScrollController();

  List<Noticia> _noticias = [];
  bool _isLoading = false;
  bool _hasError = false;
  int _paginaActual = 1;

  @override
  void initState() {
    super.initState();
    _cargarNoticiasIniciales();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _cargarNoticiasIniciales() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final noticias = await _noticiaService.obtenerNoticiasPaginadas(
        _paginaActual,
      );
      setState(() {
        _noticias = noticias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _cargarMasNoticias();
    }
  }

  Future<void> _cargarMasNoticias() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _paginaActual++;
      final nuevasNoticias = await _noticiaService.obtenerNoticiasPaginadas(
        _paginaActual,
      );

      setState(() {
        _noticias.addAll(nuevasNoticias);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _noticias.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Noticias'),
          backgroundColor: Colors.pinkAccent,
        ),
        body: const Center(child: Text(Constants.mensajeCargando)),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
          backgroundColor: Colors.pinkAccent,
        ),
        body: const Center(
          child: Text(
            Constants.mensajeError,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_noticias.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
          backgroundColor: Colors.pinkAccent,
        ),
        body: const Center(child: Text(Constants.listaVaciaNoticia)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
        backgroundColor: Colors.pinkAccent,
      ),

      body: ListView.builder(
        controller: _scrollController,
        itemCount: _noticias.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _noticias.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final noticia = _noticias[index];
          return Column(
            children: [
              const SizedBox(
                height: Constants.espaciadoAlto,
              ), // Espaciado entre el AppBar y el contenido
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contenido de la noticia
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noticia.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              noticia.descripcion,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              noticia.fuente,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Publicado el ${DateFormat('dd/MM/yyyy HH:mm').format(noticia.publicadaEl)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      // Imagen de Picsum
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://picsum.photos/100/100?random=$index',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: Constants.espaciadoAlto,
              ), // Espaciado entre los Cards
            ],
          );
        },
      ),
    );
  }
}
