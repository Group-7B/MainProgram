// screens/lesson_screen.dart
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:learning_app/data/lesson_repository.dart';
import 'package:learning_app/data/subject_repository.dart';
import 'package:learning_app/models/lesson_model.dart';
import 'package:learning_app/widgets/lesson_card.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectId = ModalRoute.of(context)!.settings.arguments as String;
    final lessons = LessonRepository.getLessonsBySubject(subjectId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${subjectId[0].toUpperCase()}${subjectId.substring(1)} Lessons'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return LessonCard(lesson: lessons[index]);
        },
      ),
    );
  }
}
