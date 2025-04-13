class Question { // Índice de la respuesta correcta

  Question({
    required this.questionText,
    required this.answerOptions,
    required this.correctAnswerIndex,
  });
  final String questionText; // Texto de la pregunta
  final List<String> answerOptions; // Opciones de respuesta
  final int correctAnswerIndex;

  // Método para verificar si una respuesta es correcta
  
}
