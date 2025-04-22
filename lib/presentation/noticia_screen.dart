import 'package:diego/constants/constants.dart';
import 'package:diego/helpers/common_widgets_herlpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diego/api/service/noticia_service.dart';
import 'package:diego/domain/entities/noticia.dart';

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
  bool ordenarPorFecha = true;
  bool ordenarPorFuente = false;
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

  Future<void> _cargarNoticiasIniciales({
    bool ordenarPorFecha = true,
    bool ordenarPorFuente = false,
  }) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final noticias = await _noticiaService.obtenerNoticiasIniciales();
      ordenarPorFecha;
      ordenarPorFuente;
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
        ordenarPorFecha: ordenarPorFecha,
        ordenarPorFuente: ordenarPorFuente,
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

  void _showAddNoticiaForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController fuenteController = TextEditingController();
    final TextEditingController fechaController = TextEditingController();
    final TextEditingController imagenUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Noticia'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El título es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fuenteController,
                    decoration: const InputDecoration(labelText: 'Fuente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La fuente es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fechaController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha (DD/MM/YYYY)',
                    ),
                    validator: (value) => validarFecha(value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la Imagen',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final nuevaNoticia = Noticia(
                    id: DateTime.now().toIso8601String(),
                    titulo: tituloController.text,
                    descripcion: descripcionController.text,
                    fuente: fuenteController.text,
                    publicadaEl: convertirFecha(fechaController.text),
                    urlImagen:
                        imagenUrlController.text.isNotEmpty
                            ? imagenUrlController.text
                            : '',
                  );

                  try {
                    await _noticiaService.crearNoticia(nuevaNoticia);

                    setState(() {
                      _noticias.insert(
                        0,
                        nuevaNoticia,
                      ); // Agregar al inicio de la lista
                    });

                    Navigator.pop(context); // Cerrar el diálogo
                  } catch (e) {
                    debugPrint('Error al crear noticia: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear noticia: $e')),
                    );
                  }
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  String? validarFecha(String? value) {
    if (value == null || value.isEmpty) {
      return 'La fecha es obligatoria';
    }

    final partes = value.split('/');
    if (partes.length != 3) {
      return 'El formato de la fecha debe ser DD/MM/YYYY';
    }

    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final anio = int.tryParse(partes[2]);

    if (dia == null || mes == null || anio == null) {
      return 'La fecha contiene valores no válidos';
    }

    try {
      DateTime(anio, mes, dia); // Verifica si la fecha es válida
    } catch (e) {
      return 'La fecha no es válida';
    }

    return null; // La fecha es válida
  }

  DateTime convertirFecha(String value) {
    final partes = value.split('/');
    final dia = int.parse(partes[0]);
    final mes = int.parse(partes[1]);
    final anio = int.parse(partes[2]);
    return DateTime(anio, mes, dia);
  }

   Future<void> _alternarOrden() async {
    if (ordenarPorFecha) {
      // Cambiar a ordenar por fuente
      await _cargarNoticiasIniciales(ordenarPorFuente: true);
      setState(() {
        ordenarPorFecha = false;
        ordenarPorFuente = true;
      });
    } else if (ordenarPorFuente) {
      // Cambiar a ordenar por fecha
      await _cargarNoticiasIniciales(ordenarPorFecha: true);
      setState(() {
        ordenarPorFecha = true;
        ordenarPorFuente = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _noticias.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
          backgroundColor: Colors.pinkAccent,
          iconTheme: const IconThemeData(
            color: Colors.white, // Cambia el color de la flecha a blanco
          ),
        ),
        body: const Center(child: Text('Cargando noticias...')),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
          backgroundColor: Colors.black87,
          iconTheme: const IconThemeData(
            color: Colors.white, // Cambia el color de la flecha a blanco
          ),
        ),
        body: const Center(
          child: Text(
            'Ocurrió un error al cargar las noticias. Inténtalo de nuevo.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_noticias.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
          backgroundColor: Colors.black87,
          iconTheme: const IconThemeData(
            color: Colors.white, // Cambia el color de la flecha a blanco
          ),
        ),
        body: const Center(child: Text('No hay noticias disponibles.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color de la flecha a blanco
        ),
        actions: [
        IconButton(
          icon: Icon(
            ordenarPorFecha ? Icons.calendar_today : Icons.sort_by_alpha,
          ),
          tooltip: ordenarPorFecha
              ? 'Ordenar por Fecha'
              : 'Ordenar por Fuente',
          onPressed: _alternarOrden,
        ),
      ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _noticias.length + (_isLoading ? 1 : 0),
        padding: EdgeInsets.zero, // Elimina cualquier padding del ListView
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
              Card(
                margin: EdgeInsets.zero, // Elimina el margen entre los cards
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.zero, // Sin bordes redondeados en el Card
                ),
                color: Colors.grey[200], // Fondo blanco para cada elemento
                child: Padding(
                  padding: const EdgeInsets.all(
                    7.0,
                  ), // Padding interno dentro del Card
                  child: Column(
                    mainAxisSize:
                        MainAxisSize
                            .min, // Evita que el Column ocupe espacio adicional
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Contenido de la noticia
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  noticia.titulo,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.5,
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
                                  'Publicado el ${DateFormat('dd/MM/yyyy HH:mm').format(noticia.publicadaEl)} • ${noticia.fuente}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          // Imagen de Picsum
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              18.0,
                            ), // Bordes redondeados
                            child: Image.network(
                              noticia.urlImagen,
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                ); // Icono de error
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ), // Espaciado entre la imagen y el Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.star_border),
                            onPressed: () {
                              // Acción para favoritos
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              // Acción para compartir
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // Acción para más opciones
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1.5, // Grosor de la línea
                color: Color.fromARGB(255, 207, 206, 206), // Color de la línea
                height: 1.5, // Altura total ocupada por el Divider
                //indent: 20.0, // Espaciado desde el lado izquierdo
                //endIndent: 20.0, // Espaciado desde el lado derecho
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoticiaForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
