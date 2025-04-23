import 'package:flutter/material.dart';
import 'package:learning_app/data/quiz_repository.dart';
import 'package:learning_app/data/subject_repository.dart';
import 'package:learning_app/models/subject_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> questions;
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  int score = 0;
  bool quizCompleted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lessonId = ModalRoute.of(context)!.settings.arguments as String;
    questions = QuizRepository.getQuizByLesson(lessonId);
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body:
            const Center(child: Text('No questions available for this lesson')),
      );
    }

    if (quizCompleted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Results')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Completed!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Your Score: $score/${questions.length}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'activity': 'Quiz Completed',
                    'score': score,
                    'totalQuestions': questions.length,
                  });
                },
                child: const Text('Back to Lessons'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1}/${questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.question,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            ...currentQuestion.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final optionText = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAnswerIndex == optionIndex
                        ? (optionIndex == currentQuestion.correctAnswerIndex
                            ? Colors.green
                            : Colors.red)
                        : null,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: selectedAnswerIndex == null
                      ? () {
                          setState(() {
                            selectedAnswerIndex = optionIndex;
                            if (optionIndex ==
                                currentQuestion.correctAnswerIndex) {
                              score++;
                            }
                          });
                        }
                      : null,
                  child: Text(optionText),
                ),
              );
            }).toList(),
            const Spacer(),
            if (selectedAnswerIndex != null)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (currentQuestionIndex < questions.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                        selectedAnswerIndex = null;
                      });
                    } else {
                      setState(() {
                        quizCompleted = true;
                      });
                    }
                  },
                  child: Text(
                    currentQuestionIndex < questions.length - 1
                        ? 'Next Question'
                        : 'See Results',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
