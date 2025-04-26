import 'package:diego/constants/constants.dart';
import 'package:diego/helpers/common_widgets_herlpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diego/data/repositories/noticia_repository.dart';
import 'package:diego/domain/entities/noticia.dart';
import 'package:diego/presentation/categorias_screen.dart';
import 'package:diego/domain/entities/categoria.dart';
import 'package:diego/data/repositories/categorias_repository.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  State<NoticiaScreen> createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaRepository _noticiaService = NoticiaRepository();
  final ScrollController _scrollController = ScrollController();

  List<Noticia> _noticias = [];
  bool _isLoading = false;
  bool _hasError = false;
  int _paginaActual = 1;
  String _mensajeError = '';
  DateTime? _ultimaActualizacion;
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    _cargarNoticiasIniciales();
    _cargarCategorias();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _cargarNoticiasIniciales() async {
    if (!mounted) return; // Evitar operaciones si el widget no está montado

    setState(() {
      _isLoading = true;
      _hasError = false;
      _mensajeError = '';
    });
    await _cargarCategorias();
    final noticias = await _noticiaService.obtenerNoticiasIniciales();

    if (!mounted)
      return; // Verificar nuevamente después de la operación asíncrona

    setState(() {
      _noticias = noticias;
      _isLoading = false;
      _ultimaActualizacion = DateTime.now();

      if (_noticiaService.hasError) {
        _hasError = true;
        _mensajeError = _noticiaService.lastErrorMessage;
      }
    });

    // Mostrar SnackBar DESPUÉS de setState y verificar mounted
    if (_noticiaService.hasError && mounted) {
      final errorInfo = _noticiaService.getErrorInfo();
      final errorMessage = errorInfo['message'];
      final errorColor = errorInfo['color'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? _noticiaService.lastErrorMessage),
          backgroundColor: errorColor,
          duration: const Duration(seconds: 5),
        ),
      );
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
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    _paginaActual++;
    final nuevasNoticias = await _noticiaService.obtenerNoticiasPaginadas(
      _paginaActual,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;

      if (_noticiaService.hasError) {
        _mensajeError = _noticiaService.lastErrorMessage;
      } else {
        _noticias.addAll(nuevasNoticias);
      }
    });

    // Mostrar SnackBar DESPUÉS de setState y verificar mounted
    if (_noticiaService.hasError && mounted) {
      final errorInfo = _noticiaService.getErrorInfo();
      final errorMessage = errorInfo['message'];
      final errorColor = errorInfo['color'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? _noticiaService.lastErrorMessage),
          backgroundColor: errorColor,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: Colors.white,
            onPressed: () {
              _cargarMasNoticias();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  // Método para cargar las categorías disponibles
  Future<void> _cargarCategorias() async {
    try {
      final categoriaRepository = CategoriaRepository();
      final categorias = await categoriaRepository.getCategorias();

      if (!mounted) return;

      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      debugPrint('Error al cargar categorías: $e');
      // No mostramos error al usuario para no interrumpir el flujo principal
    }
  }

  void _showAddNoticiaForm(BuildContext context, {Noticia? noticiaParaEditar}) {
    final bool esEdicion = noticiaParaEditar != null;
    final formKey = GlobalKey<FormState>();

    // Usar una variable local con nombre distinto para evitar confusiones
    String? selectedCategory =
        esEdicion
            ? noticiaParaEditar.categoriaId
            : Constants.defaultCategoriaId;

    final TextEditingController tituloController = TextEditingController(
      text: esEdicion ? noticiaParaEditar.titulo : '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: esEdicion ? noticiaParaEditar.descripcion : '',
    );
    final TextEditingController fuenteController = TextEditingController(
      text: esEdicion ? noticiaParaEditar.fuente : '',
    );
    final TextEditingController fechaController = TextEditingController(
      text:
          esEdicion
              ? '${noticiaParaEditar.publicadaEl.day.toString().padLeft(2, '0')}/${noticiaParaEditar.publicadaEl.month.toString().padLeft(2, '0')}/${noticiaParaEditar.publicadaEl.year}'
              : '',
    );
    final TextEditingController imagenUrlController = TextEditingController(
      text: esEdicion ? noticiaParaEditar.urlImagen : '',
    );

    showDialog(
      context: context,
      barrierDismissible: false, // Evitar cierre accidental
      builder: (dialogContext) {
        // Usar un contexto específico para el diálogo
        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            // Usar contextos específicos
            return AlertDialog(
              title: Text(esEdicion ? 'Editar Noticia' : 'Agregar Noticia'),
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
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
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
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCategory, // Usar la variable local
                        decoration: const InputDecoration(
                          labelText: 'Categoría',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: Constants.defaultCategoriaId,
                            child: const Text('Sin categoría'),
                          ),
                          ..._categorias.map((categoria) {
                            return DropdownMenuItem<String>(
                              value:
                                  categoria.id ?? Constants.defaultCategoriaId,
                              child: Text(categoria.nombre),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            // Usar setDialogState en lugar de setState
                            selectedCategory = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      dialogContext,
                    ).pop(); // Usar el contexto específico del diálogo
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (esEdicion) {
                        final noticiaActualizada = Noticia(
                          id: noticiaParaEditar.id,
                          titulo: tituloController.text,
                          descripcion: descripcionController.text,
                          fuente: fuenteController.text,
                          publicadaEl: convertirFecha(fechaController.text),
                          urlImagen:
                              imagenUrlController.text.isNotEmpty
                                  ? imagenUrlController.text
                                  : '',
                          categoriaId:
                              selectedCategory ??
                              Constants
                                  .defaultCategoriaId, // Usar la variable local
                        );

                        final exito = await _noticiaService.actualizarNoticia(
                          noticiaActualizada,
                        );

                        if (exito) {
                          Navigator.of(
                            dialogContext,
                          ).pop(); // Usar el contexto específico del diálogo

                          // Añadir un pequeño retraso antes de recargar
                          await Future.delayed(
                            const Duration(milliseconds: 1000),
                          );

                          // Verificar si el widget sigue montado antes de recargar
                          if (mounted) {
                            await _cargarNoticiasIniciales();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Noticia actualizada exitosamente',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } else {
                          final errorInfo = _noticiaService.getErrorInfo();
                          final errorMessage = errorInfo['message'];
                          final errorColor = errorInfo['color'];

                          showDialog(
                            context: builderContext, // Usar contexto específico
                            builder:
                                (errContext) => AlertDialog(
                                  title: Text(
                                    'Error',
                                    style: TextStyle(color: errorColor),
                                  ),
                                  content: Text(
                                    errorMessage ??
                                        _noticiaService.lastErrorMessage,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(errContext).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      } else {
                        final nuevaNoticia = Noticia(
                          titulo: tituloController.text,
                          descripcion: descripcionController.text,
                          fuente: fuenteController.text,
                          publicadaEl: convertirFecha(fechaController.text),
                          urlImagen:
                              imagenUrlController.text.isNotEmpty
                                  ? imagenUrlController.text
                                  : '',
                          categoriaId:
                              selectedCategory ??
                              Constants
                                  .defaultCategoriaId, // Usar la variable local
                        );

                        final success = await _noticiaService.crearNoticia(
                          nuevaNoticia,
                        );

                        if (success) {
                          Navigator.of(
                            dialogContext,
                          ).pop(); // Usar el contexto específico del diálogo

                          // Añadir un pequeño retraso antes de recargar
                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );

                          // Verificar si el widget sigue montado antes de recargar
                          if (mounted) {
                            await _cargarNoticiasIniciales();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Noticia creada exitosamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } else {
                          final errorInfo = _noticiaService.getErrorInfo();
                          final errorMessage = errorInfo['message'];
                          final errorColor = errorInfo['color'];

                          showDialog(
                            context: builderContext, // Usar contexto específico
                            builder:
                                (errContext) => AlertDialog(
                                  title: Text(
                                    'Error',
                                    style: TextStyle(color: errorColor),
                                  ),
                                  content: Text(
                                    errorMessage ??
                                        _noticiaService.lastErrorMessage,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(errContext).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(esEdicion ? 'Actualizar' : 'Agregar'),
                ),
              ],
            );
          },
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
      DateTime(anio, mes, dia);
    } catch (e) {
      return 'La fecha no es válida';
    }

    return null;
  }

  DateTime convertirFecha(String value) {
    final partes = value.split('/');
    final dia = int.parse(partes[0]);
    final mes = int.parse(partes[1]);
    final anio = int.parse(partes[2]);
    return DateTime(anio, mes, dia);
  }

  Future<void> _confirmarYEliminarNoticia(Noticia noticia) async {
    // Mostrar diálogo de confirmación
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text(
              '¿Está seguro que desea eliminar esta noticia?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    // Si el usuario confirmó, proceder con la eliminación
    if (confirmar == true) {
      if (noticia.id == null || noticia.id!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se puede eliminar - ID no disponible'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final exito = await _noticiaService.eliminarNoticia(noticia.id!);

      if (exito) {
        // Añadir un pequeño retraso antes de recargar
        await Future.delayed(const Duration(milliseconds: 1000));

        if (mounted) {
          await _cargarNoticiasIniciales();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Noticia eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final errorInfo = _noticiaService.getErrorInfo();
        final errorMessage = errorInfo['message'];
        final errorColor = errorInfo['color'];

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ?? _noticiaService.lastErrorMessage),
              backgroundColor: errorColor,
              duration: const Duration(milliseconds: 1500),
            ),
          );
        }
      }
    }
  }

  // Agregar esta función a tu clase _NoticiaScreenState
  String _getNombreCategoriaById(String? categoriaId) {
    // Caso especial: sin categoría o ID nulo
    if (categoriaId == null || categoriaId == Constants.defaultCategoriaId) {
      return 'Sin categoría';
    }

    // Buscar en la lista de categorías cargadas
    final categoriaEncontrada = _categorias.firstWhere(
      (categoria) => categoria.id == categoriaId,
      orElse:
          () => Categoria(
            id: categoriaId,
            nombre: 'Categoría desconocida',
            descripcion: '',
          ),
    );

    return categoriaEncontrada.nombre;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _noticias.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
          backgroundColor: Colors.pinkAccent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: Text(Constants.mensajeCargando)),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
          backgroundColor: Colors.black87,
          iconTheme: const IconThemeData(color: Colors.white),
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
          backgroundColor: Colors.black87,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: Text(Constants.listaVaciaNoticia)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonWidgetsHelper.buildBoldTitle(Constants.tituloApp),
            if (_ultimaActualizacion != null)
              Text(
                'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm').format(_ultimaActualizacion!)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Botón de actualización
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarNoticiasIniciales,
            tooltip: 'Actualizar noticias',
          ),
          // Botón para categorías
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriaScreen(),
                ),
              );
              // Recargar categorías y noticias al volver
              if (mounted) {
                await _cargarCategorias();
                await _cargarNoticiasIniciales();
              }
            },
            tooltip: 'Gestionar categorías',
          ),
        ],
      ),
      // RefreshIndicator para permitir pull-to-refresh
      body: RefreshIndicator(
        onRefresh: _cargarNoticiasIniciales,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _noticias.length + (_isLoading ? 1 : 0),
          padding: EdgeInsets.zero,
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
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Categoría: ${_getNombreCategoriaById(noticia.categoriaId)}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
                              child: Image.network(
                                noticia.urlImagen,
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
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
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showAddNoticiaForm(
                                  context,
                                  noticiaParaEditar: noticia,
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _confirmarYEliminarNoticia(noticia);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1.5,
                  color: Color.fromARGB(255, 207, 206, 206),
                  height: 1.5,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showAddNoticiaForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
