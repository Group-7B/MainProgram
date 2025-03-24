import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(LearningApp());
}

class LearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: LoginPage(),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              // Web/Tablet Layout
              return Row(children: [Expanded(child: child!)]);
            } else {
              // Mobile Layout
              return child!;
            }
          },
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    if (_emailController.text == 'user' && _passwordController.text == '0000') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid login ID or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: 400, // Adjust width to make input fields smaller
            child: Column(
              mainAxisSize: MainAxisSize.min, // Center elements vertically
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Login ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _login, child: Text('Login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> subjects = [];
  //List<String> subjects = [];
  late Future<void> subjectsFuture;

  @override
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
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          subjects =
              data
                  .map<Map<String, dynamic>>(
                    (subject) => subject as Map<String, dynamic>,
                  )
                  .toList();
          //subjects = data.map<String>((subject) => subject.toString()).toList();
        });
      } else {
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
      body: FutureBuilder<void>(
        future: subjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    color: Colors.purple,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        subject['subject_name'] ?? 'No Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CourseDetailScreen(
                                  courseName:
                                      subject['subject_name'] ?? 'No Name',
                                  subjectId: subject['subject_id'],
                                  topicID: 0, // Add appropriate topicID value
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final String courseName;
  final int subjectId;
  final int topicID;

  CourseDetailScreen({
    required this.courseName,
    required this.subjectId,
    required this.topicID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseName)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTopics(subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final topics = snapshot.data ?? [];
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Quiz(
                                quizName: topic['topic_name'],
                                subjectID: subjectId,
                                topicID: topic['topic_id'],
                              ),
                        ),
                      );
                      // Add your onPressed code here!
                    },
                    child: Text(topic['topic_name']),
                  ),
                );
                // return ListTile(title: Text(topics[index]));
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchTopics(int subjectId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/topics?subject_id=$subjectId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        //return data.map<String>((topic) => topic as String).toList();
        return data
            .map<Map<String, dynamic>>((topic) => topic as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to load topics');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}

class Quiz extends StatefulWidget {
  final String quizName;
  final int subjectID;
  final int topicID;

  Quiz({
    required this.quizName,
    required this.subjectID,
    required this.topicID,
  });

  _QuizGeneration createState() => _QuizGeneration(
    quizName: quizName,
    subjectID: subjectID,
    topicID: topicID,
  );
}

class _QuizGeneration extends State<Quiz> {
  final String quizName;
  final int subjectID;
  final int topicID;

  _QuizGeneration({
    required this.quizName,
    required this.subjectID,
    required this.topicID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(quizName)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchQuiz(subjectID, topicID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final quizzes = snapshot.data ?? [];
            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  QuizQuestionScreen(quizID: quiz['quiz_id']),
                        ),
                      );
                    },
                    child: Text(quiz['quiz_name']),
                  ),
                );
                // return ListTile(title: Text(topics[index]));
              },
            );
          }
        },
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchQuiz(int subjectID, int topicID) async {
  try {
    final response = await http.get(
      Uri.parse(
        'http://localhost:8000/quiz?subject_id=$subjectID&topic_id=$topicID',
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Quiz data: $data');
      return data
          .map<Map<String, dynamic>>((quiz) => quiz as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load quiz');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

class QuizQuestionScreen extends StatelessWidget {
  final int quizID;
  QuizQuestionScreen({required this.quizID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Questions')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchQuestions(quizID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final questions = snapshot.data ?? [];
            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return ListTile(title: Text(question['question_text']));
              },
            );
          }
        },
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchQuestions(int quizID) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:8000/quiz_questions?quiz_id=$quizID'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map<Map<String, dynamic>>(
            (question) => question as Map<String, dynamic>,
          )
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
