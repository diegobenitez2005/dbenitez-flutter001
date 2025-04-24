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
  //static const newUrl =
      //'https://crudcrud.com/api/3cc4f821fffa4ee381e907826a2061dc/noticias';
  static const String apiKey = '3cc4f821fffa4ee381e907826a2061dc';
  static String get newUrl => dotenv.env['NEW_URL'] ?? '';

}
