import 'package:flutter/material.dart';
import 'package:diego/api/service/question_service.dart';
import 'package:diego/domain/entities/question.dart';
import 'package:diego/presentation/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final QuestionService _questionService = QuestionService();
  late List<Question> questionsList;
  int currentQuestionIndex = 0;
  int userScore = 0;
  var color = Colors.blue;

  @override
  void initState() {
    super.initState();
    questionsList = _questionService.getQuestions();
  }

  void _handleAnswer(int selectedIndex) {
    // Llama al método isCorrect desde el servicio
    if (_questionService.isCorrect(
      questionsList[currentQuestionIndex],
      selectedIndex,
    )) {
      userScore++;
      setState(() {
        color = Colors.green; // Cambia el color del botón a verde si la respuesta es correcta
      });
    }
    else {
      setState(() {
        color = Colors.red; // Cambia el color del botón a rojo si la respuesta es incorrecta
      });
    }
      

    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < questionsList.length - 1) {
        setState(() {
          currentQuestionIndex++;
          color = Colors.blue; // Reinicia el color del botón
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: userScore),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questionsList[currentQuestionIndex];
    final questionCounterText =
        'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Juego de Preguntas'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questionCounterText,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...question.answerOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _handleAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
