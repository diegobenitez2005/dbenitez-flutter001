import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const listaVacia = 'No hay tareas';
  static const tituloAppbar = 'Mis Tareas';
  static const tipoTarea = 'Tipo:';
  static const taskTypeNormal = 'NORMAL';
  static const List<String> listaPasoVacia = [];
  static const pasasTitulo = 'Pasos para completar';
  static const fechaLimite = 'Fecha límite: ';
  static const tareaEliminada = 'Tarea eliminada';
  static const tittleApp = 'Juego de Preguntas';
  static const welcomeScreen = '¡Bienvenido al Juego de Preguntas!';
  static const startGame = 'Iniciar Juego';
  static const finalScore = 'Juego Terminado';
  static const playAgain = 'Jugar de nuevo';

  // static constantes para cotizaciones
  static const titleQuotes = 'Cotizaciones Financieras';
  static const loadingMessage = 'Cargando cotizaciones...';
  static const emptyList = 'No hay cotizaciones';
  static const errorMessage = 'Error al cargar las cotizaciones';
  static const pageSize = 10;
  static const formatoFecha = 'dd/MM/yyyy HH:mm';

  //constantes para noticias
  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVaciaNoticia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const double espaciadoAlto = 10.0;
  static String get newUrl => dotenv.env['NEW_URL'] ?? '';
  static String  get urlNoticias => '$newUrl/noticias';
  static String get urlCategorias => '$newUrl/categorias'; 
  static String defaultCategoriaId = 'Sin categoría'; 
  static int timeOutSeconds = 10; // Tiempo de espera para las peticiones HTTP
  static String messageError = 'Error al cargar las categorías';
  static String messageErrorTimeout = 'Tiempo de espera agotado';
  static const String errorUnauthorized = 'No autorizado';
  static const String errorNotFound = 'Noticias no encontradas';
  static const String errorServer = 'Error del servidor';

}
