import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      quizProvider.resetQuiz();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.quizCompleted) {
          return _buildResultsScreen(context, quizProvider);
        }
        return _buildQuestionScreen(context, quizProvider);
      },
    );
  }

  Widget _buildQuestionScreen(BuildContext context, QuizProvider quizProvider) {
    final currentQuestion =
        quizProvider.questions[quizProvider.currentQuestionIndex];
    final progress =
        (quizProvider.currentQuestionIndex + 1) / quizProvider.questions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.backgroundColor.withOpacity(0.8),
              AppTheme.primaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[800],
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        currentQuestion['question'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                      const SizedBox(height: 40),
                      _buildTimer(quizProvider),
                      const SizedBox(height: 40),
                      ...List.generate(
                        currentQuestion['options'].length,
                        (index) => _buildOptionButton(
                          context,
                          quizProvider,
                          currentQuestion['options'][index],
                          index,
                          currentQuestion['correctAnswer'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(QuizProvider quizProvider) {
    final timeLeft = quizProvider.timeLeft;
    final progress = timeLeft / 20;
    final isLowTime = timeLeft <= 5;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              isLowTime ? AppTheme.errorColor : AppTheme.primaryColor,
            ),
          ),
        ),
        Text(
          '$timeLeft',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isLowTime ? AppTheme.errorColor : Colors.white,
          ),
        )
            .animate(target: isLowTime ? 1 : 0)
            .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2))
            .shake(),
      ],
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    QuizProvider quizProvider,
    String option,
    int index,
    int correctAnswer,
  ) {
    final isSelected = quizProvider.selectedAnswerIndex == index;
    final isAnswered = quizProvider.isAnswered;
    final isCorrect = index == correctAnswer;

    Color getButtonColor() {
      if (!isAnswered) return AppTheme.surfaceColor;
      if (isSelected) {
        return isCorrect ? AppTheme.successColor : AppTheme.errorColor;
      }
      if (isCorrect) return AppTheme.successColor;
      return AppTheme.surfaceColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: isAnswered ? null : () => quizProvider.answerQuestion(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: getButtonColor(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Text(
              String.fromCharCode(65 + index),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (isAnswered && (isSelected || isCorrect))
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (300 + (index * 100)).ms).slideX(begin: 0.2);
  }

  Widget _buildResultsScreen(BuildContext context, QuizProvider quizProvider) {
    final score = quizProvider.score;
    final total = quizProvider.questions.length;
    final percentage = (score / total * 100).round();
    final averageTime = quizProvider.averageTimePerQuestion.round();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (percentage >= 70) {
        _confettiController.play();
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.backgroundColor,
                  AppTheme.backgroundColor.withOpacity(0.8),
                  AppTheme.primaryColor.withOpacity(0.2),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      percentage >= 70 ? 'Félicitations !' : 'Quiz terminé !',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ).animate().fadeIn(delay: 300.ms).scale(),
                    const SizedBox(height: 40),
                    _buildScoreCard(score, total, percentage, averageTime)
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideY(begin: 0.3),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Rejouer'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
      int score, int total, int percentage, int averageTime) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: AppTheme.surfaceColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: percentage >= 70
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $score/$total',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Temps moyen: ${averageTime}s par question',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
