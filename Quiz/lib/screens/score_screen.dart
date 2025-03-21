import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math'; // Pour l'angle aléatoire des confettis
import 'welcome_screen.dart';

class ScoreScreen extends StatefulWidget {
  final int score;
  final int total;

  const ScoreScreen({super.key, required this.score, required this.total});

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play(); // Lancer les confettis à l'arrivée
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Nettoyer le contrôleur pour éviter les fuites de mémoire
    super.dispose();
  }

  // Fonction pour choisir l'image du trophée selon le score
  String getMedalImage(int score, int total) {
    double percentage = (score / total) * 100;
    if (percentage >= 100) return "assets/images/gold.png"; // 🥇 Or
    if (percentage >= 80) return "assets/images/silver.png"; // 🥈 Argent
    if (percentage >= 50) return "assets/images/bronze.png"; // 🥉 Bronze
    return "assets/images/no_medal.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Résultats")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🎉 Confettis en arrière-plan
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            emissionFrequency: 0.08,
            numberOfParticles: 20, // Quantité de confettis
            gravity: 0.3, // Effet de gravité
          ),

          // 🏆 Carte des résultats
          Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Votre score :",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // 🏆 Affichage du Score
                    Text(
                      "${widget.score} / ${widget.total}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 20),

                    // 🏅 Affichage de la Médaille
                    Image.asset(
                      getMedalImage(widget.score, widget.total),
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text("🏆 Image introuvable", style: TextStyle(fontSize: 18, color: Colors.red));
                      },
                    ),

                    const SizedBox(height: 20),

                    // 🔄 Bouton pour recommencer
                    ElevatedButton(
                      onPressed: () {
                        _confettiController.play(); // Relancer les confettis avant de quitter
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomeScreen()),
                        );
                      },
                      child: const Text("Recommencer"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
