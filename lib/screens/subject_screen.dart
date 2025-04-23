import 'package:flutter/material.dart';
import 'package:learning_app/data/subject_repository.dart';
import 'package:learning_app/models/subject_model.dart';
import 'package:learning_app/widgets/subject_card.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = SubjectRepository.getSubjects();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return SubjectCard(subject: subjects[index]);
          },
        ),
      ),
    );
  }
}
