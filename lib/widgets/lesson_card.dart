import 'package:flutter/material.dart';
import 'package:learning_app/models/lesson_model.dart';
import 'package:learning_app/models/subject_model.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(lesson.difficulty),
                  backgroundColor: _getDifficultyColor(lesson.difficulty),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(lesson.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${lesson.duration} min',
                    style: TextStyle(color: Colors.grey[600])),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/quiz',
                      arguments: lesson.id,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text('Take Quiz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green.withOpacity(0.2);
      case 'intermediate':
        return Colors.blue.withOpacity(0.2);
      case 'advanced':
        return Colors.red.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }
}
