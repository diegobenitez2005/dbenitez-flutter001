import 'package:diego/data/repositories/question_repository.dart';
import 'package:diego/domain/entities/question.dart';

class QuestionService {
  final QuestionRepository _repository = QuestionRepository();

  // Método para obtener las preguntas desde el repositorio
  List<Question> getQuestions() {
    return _repository.getQuestions();
  }
  bool isCorrect(Question question, int selectedIndex) {
    return selectedIndex == question.correctAnswerIndex; // Verifica si la respuesta es correcta
  }
}
