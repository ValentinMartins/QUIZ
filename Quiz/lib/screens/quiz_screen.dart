import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/question.dart';
import '../services/api_service.dart';
import 'score_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  late Future<List<Question>> futureQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool isFlashing = false;
  int? selectedAnswer;
  List<Question> questions = [];
  Timer? timer;
  int timeLeft = 10;
  int timeLimit = 10;
  late AnimationController _controller;
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    futureQuestions = ApiService.fetchQuestions();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = timeLimit;
    _controller.reset();
    _controller.forward();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });


        // 🔔 Vibration forte à 1 seconde
        if (timeLeft <= 3) {
          isFlashing = !isFlashing; // Vibration plus forte
        }

      } else {
        timer.cancel();
        nextQuestion();
      }
    });
  }


  Color getTimerColor() {
    if (timeLeft > 6) return Colors.blue;
    if (timeLeft > 3) return Colors.orange;
    return Colors.red;
  }

  void playSound(bool isCorrect) async {
    String soundPath = isCorrect ? "sounds/correct.mp3" : "sounds/wrong.mp3";

    await player.play(AssetSource(soundPath)); // Chargement du son
  }

  void checkAnswer() {
    bool isCorrect = selectedAnswer == questions[currentQuestionIndex].correctIndex;
    playSound(isCorrect);
    if (isCorrect) {
      score++;
      if (timeLimit > 5) timeLimit--;
    }
    nextQuestion();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        startTimer();
      });
    } else {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ScoreScreen(score: score, total: questions.length)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: FutureBuilder<List<Question>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          questions = snapshot.data!;
          var question = questions[currentQuestionIndex];

          if (timer == null || !timer!.isActive) {
            startTimer();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40), // Ajoute un espace pour éviter la coupure
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(getTimerColor()),
                      ),
                      Center(
                        child: Text(
                          "$timeLeft s",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: getTimerColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(question.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              ),
              Column(
                children: List.generate(
                  question.options.length,
                      (index) => RadioListTile<int>(
                    title: Text(question.options[index].text),
                    value: index,
                    groupValue: selectedAnswer,
                    onChanged: (int? value) {
                      setState(() => selectedAnswer = value);
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: selectedAnswer != null ? checkAnswer : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                child: const Text("Valider", style: TextStyle(fontSize: 18)),
              ),
            ],
          );
        },
      ),
    );
  }
}
