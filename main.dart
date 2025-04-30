import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
          'http://localhost:8000/create_account',
        ), // Replace with your backend URL
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
        setState(() {
          _errorMessage = 'Failed to create account. Please try again.';
          _successMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _successMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
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
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (_successMessage.isNotEmpty)
                  Text(
                    _successMessage,
                    style: const TextStyle(color: Colors.green),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _createAccount,
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, '/skipToLogin');
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

  /*void _login() {
    
  }*/

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
        Uri.parse(
          'http://localhost:8000/login',
        ), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          userId = data["user_id"];
          print("UserID of logged user: ${userId}");
          // Navigate user to HomeScreen upon a successful login attempt
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
        setState(() {
          _errorMessage = 'Failed to log in. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
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
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: _login, child: const Text('Login')),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
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
  List<Map<String, dynamic>> subjects = []; // Store the subjects data
  bool isLoading = true; // Show a loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    fetchSubjects(); // Fetch subjects when the screen loads
  }

  Future<void> fetchSubjects() async {
    var url = Uri.parse('http://localhost:8000/subjects'); // Backend endpoint
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          subjects =
              data
                  .map<Map<String, dynamic>>(
                    (subject) => subject as Map<String, dynamic>,
                  )
                  .toList();
          isLoading = false; // Stop loading once data is fetched
        });
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subjects')),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator
              : subjects.isEmpty
              ? Center(
                child: Text('No subjects found'),
              ) // Show message if no data
              : ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CourseDetailScreen(
                                  courseName:
                                      subject['subject_name'] ?? 'No Name',
                                  subjectId: subject['subject_id'],
                                  topicID:
                                      0, // Replace with appropriate topicID value
                                ),
                          ),
                        );
                        // Handle button press (e.g., navigate to another screen)
                        print('Selected subject: ${subject['subject_name']}');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18),
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
  final int topicID;

  CourseDetailScreen({
    required this.courseName,
    required this.subjectId,
    required this.topicID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
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

class QuizQuestionScreen extends StatefulWidget {
  final int quizID;

  QuizQuestionScreen({required this.quizID});

  @override
  _QuizQuestionScreenState createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Map<int, String> selectedAnswersOfUser = {}; // Stores user's selected answers
  late Future<List<Map<String, dynamic>>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = fetchQuestionAndAnswers(widget.quizID);
  }

  void _checkAnswers(List<Map<String, dynamic>> questions) {
    int correctAnswers = 0;
    int totalQuestions = questions.length;
    List<Map<String, dynamic>> attempts = [];
    for (var question in questions) {
      final questionId = question['question_id'];
      final answers = question['answers'] as List<dynamic>;

      String? correctAnswer;

      // Find the correct answer
      for (var answer in answers) {
        if (answer['is_correct'] == true) {
          correctAnswer = answer['answer_text'];
          break;
        }
      }

      final userAnswer =
          selectedAnswersOfUser[questionId]; // Comparing the user's answer with the correct answer
      if (userAnswer != null && userAnswer == correctAnswer) {
        correctAnswers++;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Result:"),
          content: Text("$correctAnswers / $totalQuestions correct"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _submitAttempts(List<Map<String, dynamic>> questions) async {
    List<Map<String, dynamic>> attempts = [];

    for (var question in questions) {
      final questionId = question['question_id'];
      final answers = question['answers'] as List<dynamic>;
      int? correctAnswerId;
      int? selectedAnswerId;

      // Find the correct answer
      for (var answer in answers) {
        if (answer['is_correct'] == true) {
          correctAnswerId = answer['answer_id'];
        }
        if (selectedAnswersOfUser[questionId] == answer['answer_text']) {
          selectedAnswerId = answer['answer_id'];
        }
      }

      print("Question ID: $questionId");
      print("Selected Answer ID: $selectedAnswerId");
      print("Correct Answer ID: $correctAnswerId");

      // Add the attempt to the list
      attempts.add({
        'question_id': questionId,
        'answer_id': selectedAnswerId,
        'is_correct': selectedAnswerId == correctAnswerId,
      });
    }

    print(attempts);
    // Send the data to the backend
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/submit_attempts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId, 'attempts': attempts}),
      );

      if (response.statusCode == 200) {
        print("Attempts submitted successfully");
      } else {
        print("Failed to submit attempts: ${response.body}");
      }
    } catch (e) {
      print("Error submitting attempts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Questions')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final questions = snapshot.data ?? [];
            if (questions.isEmpty) {
              return Center(child: Text("No questions found."));
            }

            return PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return QuestionPage(
                  question: question,
                  selectedAnswersOfUser: selectedAnswersOfUser,
                  currentPage: _currentPage,
                  totalQuestions: questions.length,
                  onNext: () {
                    if (_currentPage < questions.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _submitAttempts(
                        questions,
                      ); // _submitAttempt called to submit attempts
                      _checkAnswers(questions);
                    }
                  },
                  onPrevious: () {
                    if (_currentPage > 0) {
                      _pageController.previousPage(
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
  final Map<int, String> selectedAnswersOfUser;
  final int currentPage;
  final int totalQuestions;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  QuestionPage({
    required this.question,
    required this.selectedAnswersOfUser,
    required this.currentPage,
    required this.totalQuestions,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final answers = question['answers'] as List<dynamic>;
    final questionId = question['question_id'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question['question_text'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...answers.map((answer) {
            final answerText = answer['answer_text'];
            final isSelected = selectedAnswersOfUser[questionId] == answerText;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected
                          ? Colors.blue
                          : null, // This is to make sure the user's selected answer is highlighted so they know what answer has been selected.
                ),
                onPressed: () {
                  // Save the selected answer
                  selectedAnswersOfUser[questionId] = answerText;
                  print(
                    "Selected answer for question $questionId: $answerText",
                  );
                },
                child: Text(answerText),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentPage > 0 ? onPrevious : null,
                child: Text("Previous"),
              ),
              ElevatedButton(
                onPressed: onNext,
                child: Text(
                  currentPage < totalQuestions - 1 ? "Next" : "Submit",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* OLD VERSION BELOW: */
/*class QuizQuestionScreen extends StatelessWidget {
  final int quizID;
  QuizQuestionScreen({required this.quizID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Questions')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchQuestionAndAnswers(quizID),
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
} */

Future<List<Map<String, dynamic>>> fetchQuestionAndAnswers(int quizID) async {
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
      throw Exception('Failed to load questions and answers');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
