import 'package:flutter/material.dart';
import 'package:diego/presentation/start_screen.dart';

class ResultScreen extends StatelessWidget {

  const ResultScreen({
    super.key,
    required this.finalScore,
    required this.totalQuestions,
  });
  final int finalScore;
  final int totalQuestions;


  @override
  Widget build(BuildContext context) {
    // Texto del puntaje final
    double spacingHeight = 20.0;
    final String scoreText = 'Puntuación Final: $finalScore/$totalQuestions';
    SizedBox(height: spacingHeight);
    // Mensaje de retroalimentación
    final String feedbackMessage =
        finalScore > (totalQuestions / 2)
            ? '¡Buen trabajo!'
            : '¡Sigue practicando!';
    final Color buttonColor =
        finalScore > (totalQuestions / 2) 
            ? Colors.blue 
            : Colors.red;
    // Estilo del texto del puntaje
    const TextStyle scoreTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(scoreText, style: scoreTextStyle, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Text(
              feedbackMessage,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                  (route) => false, // Elimina todas las pantallas anteriores
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Jugar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}
