import 'package:diego/domain/entities/question.dart';

class QuestionRepository {
  static final List<Question> initialQuestions = [
    Question(
      questionText: '¿Cuál es la capital de Francia?',
      answerOptions: ['Madrid', 'París', 'Roma'],
      correctAnswerIndex: 1, // París
    ),
    Question(
      questionText: '¿Cuál es el planeta más grande del sistema solar?',
      answerOptions: ['Tierra', 'Júpiter', 'Marte'],
      correctAnswerIndex: 1, // Júpiter
    ),
    Question(
      questionText: '¿En qué año llegó el hombre a la Luna?',
      answerOptions: ['1965', '1969', '1972'],
      correctAnswerIndex: 1, // 1969
    ),
    Question(
      questionText: '¿Cuál es el océano más grande del mundo?',
      answerOptions: ['Atlántico', 'Índico', 'Pacífico'],
      correctAnswerIndex: 2, // Pacífico
    ),
  ];

  // Método para obtener todas las preguntas
  List<Question> getQuestions() {
    return List.from(initialQuestions);
  }
}
