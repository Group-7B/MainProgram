// models/subject_model.dart
import 'dart:ui' show Color;

class Subject {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final Color color;

  Subject({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
  });
}

// models/lesson_model.dart
class Lesson {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final String content;
  final int duration; // in minutes
  final String difficulty;
  final List<String> tags;

  Lesson({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.content,
    required this.duration,
    required this.difficulty,
    required this.tags,
  });
}

// models/quiz_model.dart
class QuizQuestion {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}
