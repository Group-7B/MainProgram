import 'package:learning_app/models/subject_model.dart' show QuizQuestion;

class QuizRepository {
  static List<QuizQuestion> getQuizByLesson(String lessonId) {
    switch (lessonId) {
      case 'math1': // Algebra Basics
        return [
          QuizQuestion(
            id: 'q1',
            lessonId: 'math1',
            question: 'What is the value of x in 2x + 3 = 7?',
            options: ['1', '2', '3', '4'],
            correctAnswerIndex: 1,
          ),
          QuizQuestion(
            id: 'q2',
            lessonId: 'math1',
            question: 'Simplify: 3(x + 2)',
            options: ['3x + 2', 'x + 6', '3x + 6', '3x + 5'],
            correctAnswerIndex: 2,
          ),
        ];
      case 'math2': // Geometry Fundamentals
        return [
          QuizQuestion(
            id: 'q1',
            lessonId: 'math2',
            question: 'How many degrees are in a triangle?',
            options: ['90', '180', '270', '360'],
            correctAnswerIndex: 1,
          ),
        ];
      // Add more lessons here
      default:
        return [
          QuizQuestion(
            id: 'default',
            lessonId: 'default',
            question: 'Sample question',
            options: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
            correctAnswerIndex: 0,
          ),
        ];
    }
  }
}
