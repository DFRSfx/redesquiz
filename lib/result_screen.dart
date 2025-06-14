import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int level;

  const QuizResultScreen({super.key, required this.score, required this.level});

  @override
  Widget build(BuildContext context) {
    final isPass = score > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: const Color(0xFF1E1E2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPass ? Icons.check_circle : Icons.error,
                    size: 80,
                    color: isPass ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isPass ? 'Parabéns!' : 'Tente Novamente',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Nível $level Concluído',
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Pontuação: $score',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        child: const Text('Menu Principal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
