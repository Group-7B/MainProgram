import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'leaderboard.dart';

int? userId;

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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: LoginPage(),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                children: [
                  Expanded(
                    child: child!,
                  )
                ],
              );
            } else {
              return child!;
            }
          },
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';

  Future<void> _createAccount() async {
    final String name = _nameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
        _successMessage = '';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/create_account'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_name': name,
          'user_last_name': lastName,
          'user_email': email,
          'user_password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _successMessage = data['message'] ?? 'Account created successfully!';
          _errorMessage = '';
        });
      } else {
        final data = json.decode(response.body);
        setState(() {
          _errorMessage =
              data['error'] ?? 'Failed to create account. Please try again.';
          _successMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}. Please try again.';
        _successMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create an Account',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'First Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                      labelText: 'Last Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_successMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _successMessage,
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _createAccount,
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Log in',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password are required.';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          userId = data["user_id"];
          print("UserID of logged user: $userId");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'Invalid email or password.';
          });
        }
      } else {
        final data = json.decode(response.body);
        setState(() {
          _errorMessage =
              data['error'] ?? 'Failed to log in. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _login,
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Navigate to LoginPage (Sign Up)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text(
                    'Don’t have an account? Sign up',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
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
  bool isLoading = true;
  int? userLevel;
  bool loadinglevel = true;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    fetchUserLevel();
  }

  Future<void> fetchSubjects() async {
    var url = Uri.parse('http://localhost:8000/subjects');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          subjects = data
              .map<Map<String, dynamic>>(
                (subject) => subject as Map<String, dynamic>,
              )
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to load subjects. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching subjects: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserLevel() async {
    if (userId == null) {
      print("User ID is null, cannot fetch level.");
      if (mounted) {
        setState(() {
          loadinglevel = false;
          userLevel = null;
        });
      }
      return;
    }
    try {
      final response = await http
          .get(
            Uri.parse('http://localhost:8000/userLevel?user_id=$userId'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            if (data['success'] == true) {
              userLevel = data['user_level'] as int;
            } else {
              print(
                  'Failed to get user level from backend: ${data['user_level']}');
              userLevel = null;
            }
            loadinglevel = false;
          });
        }
      } else {
        print('Failed to load user level. Status code: ${response.statusCode}');
        if (mounted) {
          setState(() {
            loadinglevel = false;
            userLevel = null;
          });
        }
      }
    } catch (e) {
      print('Error fetching user level: $e');
      if (mounted) {
        setState(() {
          loadinglevel = false;
          userLevel = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: loadinglevel
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2.0,
                      ),
                    )
                  : Text(
                      userLevel != null ? 'Level: $userLevel' : 'Level: N/A',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.leaderboard, color: Colors.white),
            tooltip: 'Leaderboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Leaderboard()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : subjects.isEmpty
              ? Center(
                  child: Text('No subjects found. Please try again later.'))
              : ListView.builder(
                  itemCount: subjects.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailScreen(
                                courseName: subject['subject_name'] ??
                                    'Unnamed Subject',
                                subjectId: subject['subject_id'],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 18.0),
                          textStyle:
                              TextStyle(fontSize: 18, color: Colors.black),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(subject['subject_name'] ?? 'No Name'),
                      ),
                    );
                  },
                ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final String courseName;
  final int subjectId;

  CourseDetailScreen({
    required this.courseName,
    required this.subjectId,
  });

  Future<List<Map<String, dynamic>>> fetchTopics(int subjectId) async {
    try {
      final response = await http
          .get(
            Uri.parse('http://localhost:8000/topics?subject_id=$subjectId'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map<Map<String, dynamic>>((topic) => topic as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception(
            'Failed to load topics. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching topics for subject $subjectId: $e');
      throw Exception('Error fetching topics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTopics(subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Error loading topics: ${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red)),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No topics found for this subject."));
          } else {
            final topics = snapshot.data!;
            return ListView.builder(
              itemCount: topics.length,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final topic = topics[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizListScreen(
                            topicName: topic['topic_name'] ?? 'Unnamed Topic',
                            subjectID: subjectId,
                            topicID: topic['topic_id'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      textStyle: TextStyle(fontSize: 16, color: Colors.black),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(topic['topic_name'] ?? 'No Name'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class QuizListScreen extends StatelessWidget {
  final String topicName;
  final int subjectID;
  final int topicID;

  QuizListScreen({
    required this.topicName,
    required this.subjectID,
    required this.topicID,
  });

  Future<List<Map<String, dynamic>>> fetchQuizzesForTopic(
      int subjectID, int topicID) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                'http://localhost:8000/quiz?subject_id=$subjectID&topic_id=$topicID'),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Quiz data for topic $topicID: $data');
        return data
            .map<Map<String, dynamic>>((quiz) => quiz as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception(
            'Failed to load quizzes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quizzes for topic $topicID: $e');
      throw Exception('Error fetching quizzes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes for ${topicName}',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchQuizzesForTopic(subjectID, topicID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Error loading quizzes: ${snapshot.error}",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No quizzes found for this topic."));
          } else {
            final quizzes = snapshot.data!;
            return ListView.builder(
              itemCount: quizzes.length,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakingQuiz(
                            quizID: quiz['quiz_id'],
                            quizName: quiz['quiz_name'] ?? 'Unnamed Quiz',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      textStyle: TextStyle(fontSize: 16, color: Colors.black),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(quiz['quiz_name'] ?? 'Unnamed Quiz'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class TakingQuiz extends StatefulWidget {
  final int quizID;
  final String quizName;

  TakingQuiz({required this.quizID, required this.quizName});

  @override
  TakingQuizState createState() => TakingQuizState();
}

class TakingQuizState extends State<TakingQuiz> {
  final PageController pageController = PageController();
  int _currentPage = 0;
  Map<int, int?> selectedAnswerId = {};
  late Future<List<Map<String, dynamic>>> futureQuestions;
  Map<String, dynamic> updatedScore = {};

  @override
  void initState() {
    super.initState();
    futureQuestions = loadQuizData();
  }

  Future<File> getLocalFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$filename');
  }

  Future<void> saveQuizDataToCache(List<Map<String, dynamic>> data) async {
    if (data.isEmpty) return;
    try {
      final file = await getLocalFile('quiz_${widget.quizID}.json');
      await file.writeAsString(json.encode(data));
      print('Quiz ${widget.quizID} data saved to cache.');
    } catch (e) {
      print('Error saving quiz data to cache: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadQuizDataFromCache() async {
    try {
      final file = await getLocalFile('quiz_${widget.quizID}.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          final List<dynamic> jsonData = json.decode(contents);
          print('Quiz ${widget.quizID} data loaded from cache.');
          return jsonData
              .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
              .toList();
        }
      }
    } catch (e) {
      print('Error loading quiz data from cache: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchQuestionsFromApi() async {
    try {
      final response = await http
          .get(
            Uri.parse(
                'http://localhost:8000/quiz_questions?quiz_id=${widget.quizID}'),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final questions = data
            .map<Map<String, dynamic>>(
                (question) => question as Map<String, dynamic>)
            .toList();
        await saveQuizDataToCache(questions);
        return questions;
      } else {
        throw Exception(
            'Failed to load questions and answers. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching questions from API for quiz ${widget.quizID}: $e');
      throw Exception('API Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadQuizData() async {
    List<Map<String, dynamic>> cachedData = await loadQuizDataFromCache();
    if (cachedData.isNotEmpty) {
      return cachedData;
    }
    return fetchQuestionsFromApi();
  }

  void showResultsDialog(int correctAnswers, int totalQuestions,
      List<Map<String, dynamic>> detailedResults) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz Results"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You scored: $correctAnswers / $totalQuestions",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                Text("Details:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...detailedResults.map((result) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "Q: ${result['question_text']}\nYour Answer: ${result['user_answer_text'] ?? 'Not answered'}\nCorrect: ${result['is_correct'] ? 'Yes' : 'No'}${!result['is_correct'] ? '\nCorrect Answer: ${result['correct_answer_text']}' : ''}",
                      style: TextStyle(
                          color: result['is_correct']
                              ? Colors.green
                              : Colors.red.shade700),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateTheScore(int currentUserId, int scoreAchieved) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://localhost:8000/update_score'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'user_id': currentUserId,
              'score_achieved': scoreAchieved,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Score update response: $data");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(data['message'] ?? 'Score updated!'),
                backgroundColor: Colors.green),
          );
        }
        updatedScore = data;
      } else {
        final data = json.decode(response.body);
        print("Failed to update score: ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Error updating score: ${data['error'] ?? response.reasonPhrase}"),
              backgroundColor: Colors.red));
        }
        updatedScore = {
          'success': false,
          'message': data['error'] ?? 'Failed to update score'
        };
      }
    } catch (e) {
      print("Error updating score: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Network error updating score: ${e.toString()}"),
            backgroundColor: Colors.red));
      }
      updatedScore = {
        'success': false,
        'message': 'Network error updating score'
      };
    }
  }

  void submitAndCheckAnswers(List<Map<String, dynamic>> questions) async {
    if (userId == null) {
      print("User ID is null. Cannot submit attempts.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Error: User not logged in. Cannot submit results.")));
      }
      return;
    }

    int correctAnswersCount = 0;
    List<Map<String, dynamic>> attempts = [];
    List<Map<String, dynamic>> resultsForDialog = [];

    for (var question in questions) {
      final questionId = question['question_id'] as int;
      final List<dynamic> answersList = question['answers'] as List<dynamic>;

      int? selectedUserAnswerId = selectedAnswerId[questionId];
      String? userAnswerText;
      String? correctAnswerText;
      int? correctAnswerId;
      bool isUserCorrect = false;

      for (var answer in answersList) {
        if (answer['is_correct'] == true) {
          correctAnswerId = answer['answer_id'] as int;
          correctAnswerText = answer['answer_text'] as String;
        }
        if (answer['answer_id'] == selectedUserAnswerId) {
          userAnswerText = answer['answer_text'] as String;
        }
      }

      if (selectedUserAnswerId != null &&
          selectedUserAnswerId == correctAnswerId) {
        correctAnswersCount++;
        isUserCorrect = true;
      }

      if (selectedUserAnswerId != null) {
        attempts.add({
          'question_id': questionId,
          'answer_id': selectedUserAnswerId,
          'is_correct': isUserCorrect,
        });
      }
      resultsForDialog.add({
        'question_text': question['question_text'],
        'user_answer_text': userAnswerText,
        'correct_answer_text': correctAnswerText,
        'is_correct': isUserCorrect,
      });
    }

    if (userId != null && attempts.isNotEmpty) {
      try {
        final response = await http
            .post(
              Uri.parse('http://localhost:8000/submit_attempts'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'user_id': userId, 'attempts': attempts}),
            )
            .timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          print("Attempts submitted successfully to backend.");
        } else {
          print("Failed to submit attempts to backend: ${response.body}");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Error submitting results to server. Status: ${response.statusCode}")));
          }
        }
      } catch (e) {
        print("Error submitting attempts to backend: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("Network error submitting results: ${e.toString()}")));
        }
      }
    } else if (userId == null) {
      print("User not logged in, skipping backend submission.");
    } else if (attempts.isEmpty) {
      print(
          "No answers selected for any question, skipping backend submission.");
    }

    if (userId != null) {
      await updateTheScore(userId!, correctAnswersCount);
    }

    if (mounted) {
      showResultsDialog(
          correctAnswersCount, questions.length, resultsForDialog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizName, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Error loading quiz: ${snapshot.error}",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No questions found for this quiz."));
          } else {
            final questions = snapshot.data!;
            return PageView.builder(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final questionId = question['question_id'] as int;
                return QuestionPage(
                  question: question,
                  selectedAnswerId: selectedAnswerId[questionId],
                  onAnswerSelected: (answerId) {
                    setState(() {
                      selectedAnswerId[questionId] = answerId;
                    });
                  },
                  currentPage: _currentPage,
                  totalQuestions: questions.length,
                  onNext: () {
                    if (_currentPage < questions.length - 1) {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      submitAndCheckAnswers(questions);
                    }
                  },
                  onPrevious: () {
                    if (_currentPage > 0) {
                      pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class QuestionPage extends StatelessWidget {
  final Map<String, dynamic> question;
  final int? selectedAnswerId;
  final Function(int) onAnswerSelected;
  final int currentPage;
  final int totalQuestions;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  QuestionPage({
    required this.question,
    required this.selectedAnswerId,
    required this.onAnswerSelected,
    required this.currentPage,
    required this.totalQuestions,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> answers = question['answers'] as List<dynamic>;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Question ${currentPage + 1} of $totalQuestions",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                question['question_text'] as String,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final answer = answers[index] as Map<String, dynamic>;
                final answerText = answer['answer_text'] as String;
                final answerId = answer['answer_id'] as int;
                final isSelected = selectedAnswerId == answerId;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.green.shade600
                          : Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 12.0),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: isSelected ? 4 : 2,
                    ),
                    onPressed: () {
                      onAnswerSelected(answerId);
                    },
                    child: Text(answerText, textAlign: TextAlign.center),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentPage > 0 ? onPrevious : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text("Previous", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: selectedAnswerId != null ? onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                    currentPage < totalQuestions - 1 ? "Next" : "Submit Quiz",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension on int? {
  bool containsKey(dynamic question) {
    return this != null;
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
      print('Quiz data (from fetchQuiz): $data');
      return data
          .map<Map<String, dynamic>>((quiz) => quiz as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load quiz (from fetchQuiz)');
    }
  } catch (e) {
    print('Error (from fetchQuiz): $e');
    return [];
  }
}
