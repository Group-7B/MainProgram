// data/subject_repository.dart
import 'package:flutter/material.dart';
import '../models/subject_model.dart';

class SubjectRepository {
  static List<Subject> getSubjects() {
    return [
      Subject(
        id: 'math',
        title: 'Mathematics',
        description: 'Learn algebra, geometry, calculus and more',
        imagePath: 'assets/images/math.png',
        color: Colors.blue,
      ),
      Subject(
        id: 'english',
        title: 'English',
        description: 'Improve grammar, vocabulary and literature',
        imagePath: 'assets/images/english.png',
        color: Colors.red,
      ),
      Subject(
        id: 'science',
        title: 'Science',
        description: 'Explore biology, chemistry and earth science',
        imagePath: 'assets/images/science.png',
        color: Colors.green,
      ),
      Subject(
        id: 'physics',
        title: 'Physics',
        description: 'Understand motion, energy and the universe',
        imagePath: 'assets/images/physics.png',
        color: Colors.purple,
      ),
    ];
  }
}

// data/lesson_repository.dart

class LessonRepository {
  static List<Lesson> getLessonsBySubject(String subjectId) {
    switch (subjectId) {
      case 'math':
        return [
          Lesson(
            id: 'math1',
            subjectId: 'math',
            title: 'Algebra Basics',
            description: 'Introduction to algebraic expressions and equations',
            content: 'Algebra is a branch of mathematics...',
            duration: 30,
            difficulty: 'Beginner',
            tags: ['algebra', 'equations', 'variables'],
          ),
          Lesson(
            id: 'math2',
            subjectId: 'math',
            title: 'Geometry Fundamentals',
            description: 'Understanding shapes, angles and theorems',
            content: 'Geometry is the study of shapes and spaces...',
            duration: 45,
            difficulty: 'Beginner',
            tags: ['geometry', 'shapes', 'angles'],
          ),
        ];
      case 'english':
        return [
          Lesson(
            id: 'eng1',
            subjectId: 'english',
            title: 'Grammar Essentials',
            description: 'Master the basics of English grammar',
            content: 'Grammar is the system of a language...',
            duration: 25,
            difficulty: 'Beginner',
            tags: ['grammar', 'tenses', 'parts of speech'],
          ),
          Lesson(
            id: 'eng2',
            subjectId: 'english',
            title: 'Vocabulary Building',
            description: 'Expand your word knowledge',
            content: 'A rich vocabulary helps in effective communication...',
            duration: 35,
            difficulty: 'Intermediate',
            tags: ['vocabulary', 'words', 'language'],
          ),
        ];
      case 'science':
        return [
          Lesson(
            id: 'sci1',
            subjectId: 'science',
            title: 'Cell Biology',
            description: 'Learn about the building blocks of life',
            content: 'Cells are the basic structural and functional units...',
            duration: 40,
            difficulty: 'Beginner',
            tags: ['biology', 'cells', 'microscope'],
          ),
          Lesson(
            id: 'sci2',
            subjectId: 'science',
            title: 'Chemical Reactions',
            description: 'Understand how substances interact',
            content: 'A chemical reaction is a process...',
            duration: 50,
            difficulty: 'Intermediate',
            tags: ['chemistry', 'reactions', 'elements'],
          ),
        ];
      case 'physics':
        return [
          Lesson(
            id: 'phy1',
            subjectId: 'physics',
            title: 'Newton\'s Laws',
            description: 'The fundamental principles of motion',
            content: 'Newton\'s laws describe the relationship...',
            duration: 45,
            difficulty: 'Beginner',
            tags: ['motion', 'force', 'newton'],
          ),
          Lesson(
            id: 'phy2',
            subjectId: 'physics',
            title: 'Electromagnetism',
            description: 'Electricity and magnetism explained',
            content: 'Electromagnetism is a branch of physics...',
            duration: 60,
            difficulty: 'Advanced',
            tags: ['electricity', 'magnetism', 'fields'],
          ),
        ];
      default:
        return [];
    }
  }
}
