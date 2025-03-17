import 'package:flutter/material.dart';
import 'coursescreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(LearningAppHome());
}

class LearningAppHome extends StatelessWidget {
  const LearningAppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<String> subjects = [];
  late Future<void> subjectsFuture;

  void initState() {
    super.initState();
    subjectsFuture = fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/subjects'),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        setState(() {
          subjects = List<String>.from(json.decode(response.body));
          print(subjects);
        });
        print('Subjects: $subjects');
      } else {
        print('Failed to load subjects. Status code: ${response.statusCode}');
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Subject')),
      body: SingleChildScrollView(
        child: 
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            SizedBox(
              height: 40,
              width: 40,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CourseListScreen(category: "Mathematics")));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/your_image.png',
                            width: 50, height: 50),
                        SizedBox(height: 8),
                        Text("Mathematics"),
                      ],
                    )),
                //Next item
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
