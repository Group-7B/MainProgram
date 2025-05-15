import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'leaderboard.dart';
import 'profile_screen.dart';

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

// first page login, this is so it is prompted upon loading the site
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<LoginPage> {
  // variables to store inputted data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';
// function to send entered data to the database so account can be created
  Future<void> _createAccount() async {
    final String name = _nameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    //preventing the user from missing a field, would cause issues in the program if data is missing
    if (name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
        _successMessage = '';
      });
      return;
    }
    //connect to database to send data off
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
      //if data is all correct it is sent to the database and account is created successfully
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _successMessage = data['message'] ?? 'Account created successfully!';
          _errorMessage = '';
        });
        // if there is an error located, the program lets the user know and wont send data to the database
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

// sign up page UI
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

// login page, activeated upon button press in sing in page
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
    //variables for inputted data to be saved to
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    // preventing a field from being empty
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password are required.';
      });
      return;
    }
    //connect to the database
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/login'),
        headers: {'Content-Type': 'application/json'},
        //send data to database
        body: json.encode({'email': email, 'password': password}),
      );
      //is data is sent successfully
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //checking to see if the details match
        if (data['success'] == true) {
          userId = data["user_id"];
          print("UserID of logged user: $userId");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          //if details dont match, through erroe allow for re entry
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'Invalid email or password.';
          });
        }
        //error checking
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

// log in body
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

// Home page (subject page)
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variables to store displayed information from the database
  List<Map<String, dynamic>> subjects = [];
  bool isLoading = true;
  int? userLevel;
  bool loadinglevel = true;
  //Gemini integration
  final TextEditingController geminiController = TextEditingController();
  String responseAI = '';
  bool geminiLoading = false;
  String apiKey = 'AIzaSyBPk-DoWpDkUCsZO9zaabCtBeZHMn-rsxA';

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    fetchUserLevel();
  }

  // fetching subjects from database to display
  Future<void> fetchSubjects() async {
    // using the subjects function in the doGet backend
    var url = Uri.parse('http://localhost:8000/subjects');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      // store results to a map so they can be loaded
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
        // if error is found, display backend reason
      } else {
        print('Failed to load subjects. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
      // exception handling
    } catch (e) {
      print('Error fetching subjects: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // fetch user level data to display
  Future<void> fetchUserLevel() async {
    // if no user id, through error in console, dont display any information
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
    // if user id is found run the userlevel function in the backend
    try {
      final response = await http
          .get(
            Uri.parse('http://localhost:8000/userLevel?user_id=$userId'),
          )
          .timeout(const Duration(seconds: 10));
      // if data is collected, store data to display
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            if (data['success'] == true) {
              userLevel = data['user_level'] as int;
            } else {
              // error handling if a level isnt found
              print(
                  'Failed to get user level from backend: ${data['user_level']}');
              userLevel = null;
            }
            loadinglevel = false;
          });
        }
        // unable to find user level handling
      } else {
        print('Failed to load user level. Status code: ${response.statusCode}');
        if (mounted) {
          setState(() {
            loadinglevel = false;
            userLevel = null;
          });
        }
      }
      // exception handling
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

  //GEMINI INTEGRATION
  void geminiDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return LayoutBuilder(builder: (context, constraints) {
                //Alert box to use gemini
                return AlertDialog(
                  title: const Text('Gemini 2.0 Flash'),
                  content: SizedBox(
                    width: constraints.maxWidth * 0.9,
                    height: constraints.maxHeight * 0.7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: geminiController,
                          decoration: const InputDecoration(
                            hintText: 'Ask Gemini',
                          ),
                          maxLines: null,
                        ),
                        //spacer
                        const SizedBox(height: 20),
                        if (geminiLoading) const CircularProgressIndicator(),
                        if (responseAI.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              // Scrollbar incase text is too big
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    'Gemini Response:\n$responseAI',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          geminiController.clear();
                          setState(() {
                            responseAI = '';
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel')),
                    //prompt button
                    ElevatedButton(
                      onPressed: () async {
                        if (geminiLoading) return;
                        setState(() {
                          geminiLoading = true;
                          responseAI = '';
                        });
                        final prompt = geminiController.text;
                        if (prompt.isEmpty) {
                          setState(() {
                            responseAI = 'How can I help you?';
                            geminiLoading = false;
                          });
                          return;
                        }
                        //exception handler
                        try {
                          //initialise model
                          final generativeModel = GenerativeModel(
                              model: 'gemini-2.0-flash', apiKey: apiKey);
                          final content = [Content.text(prompt)];
                          final response =
                              await generativeModel.generateContent(content);
                          setState(() {
                            responseAI =
                                response.text ?? 'Gemini is not responding';
                            geminiLoading = false;
                          });
                          //incase of unexpected error
                        } catch (e) {
                          setState(() {
                            responseAI = 'Error: $e';
                            geminiLoading = false;
                          });
                        }
                      },
                      child: Text('Ask'),
                    ),
                  ],
                );
              });
            },
          );
        });
  }

// Subjects page content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar contains the subjects text, user level, leaderboard + profile buttons
      appBar: AppBar(
        title: Text('Subjects', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
        actions: <Widget>[
          //Level display
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
                  //displaying the level in the text, display N/A id not found
                  : Text(
                      userLevel != null ? 'Level: $userLevel' : 'Level: N/A',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
          //Gemini Button
          IconButton(
            icon: const Icon(Icons.star, color: Colors.white),
            tooltip: 'Ask Gemini',
            onPressed: geminiDialog,
          ),
          //leaderboard button
          IconButton(
            icon: Icon(Icons.leaderboard, color: Colors.white),
            tooltip: 'Leaderboard',
            onPressed: () {
              Navigator.push(
                context,
                // go to leaderboard page
                MaterialPageRoute(builder: (context) => Leaderboard()),
              );
            },
          ),
          //profile page button
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                //load profile page and send the users user id to the page so the data can be loaded
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: userId!)),
              );
            },
          ),
        ],
      ),
      // displaying subjects buttons
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : subjects.isEmpty
              ? Center(
                  child: Text('No subjects found. Please try again later.'))
              //list builder to generate buttons based on data in the map
              : ListView.builder(
                  itemCount: subjects.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 8.0),
                      //button which has and loads the subject
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //button command will load a button that will send the user to the course detaisl page that correstponds with the subject
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

// course details screen
class CourseDetailScreen extends StatelessWidget {
  final String courseName;
  final int subjectId;

  CourseDetailScreen({
    // variables to store data used to load and fetch course information
    required this.courseName,
    required this.subjectId,
  });
  //fetch topic data from backend function using the subject id
  Future<List<Map<String, dynamic>>> fetchTopics(int subjectId) async {
    try {
      final response = await http
          .get(
            Uri.parse('http://localhost:8000/topics?subject_id=$subjectId'),
          )
          .timeout(const Duration(seconds: 10));
      // if subject id is valid, fetch course data associated with that subject id
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map<Map<String, dynamic>>((topic) => topic as Map<String, dynamic>)
            .toList();
        //incase of error through a error
      } else {
        throw Exception(
            'Failed to load topics. Status code: ${response.statusCode}');
      }
      // exception handling
    } catch (e) {
      print('Error fetching topics for subject $subjectId: $e');
      throw Exception('Error fetching topics: $e');
    }
  }

  //course details page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
      ), // dynamically load the data from the map information
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTopics(subjectId),
        builder: (context, snapshot) {
          //if no data is found through error
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
            //if data dound use list builder to generate buttons depending on what data is in the map
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
                          // loads quizes based on relavant course id information
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

// quiz screen
class QuizListScreen extends StatelessWidget {
  // variables that store the data sent from the course screen
  final String topicName;
  final int subjectID;
  final int topicID;

  QuizListScreen({
    //data is required in order to load quizzes
    required this.topicName,
    required this.subjectID,
    required this.topicID,
  });
  //fetch the quiz
  Future<List<Map<String, dynamic>>> fetchQuizzesForTopic(
      int subjectID, int topicID) async {
    //run the backend function to find the quiz data
    try {
      final response = await http
          .get(
            Uri.parse(
                'http://localhost:8000/quiz?subject_id=$subjectID&topic_id=$topicID'),
          )
          .timeout(const Duration(seconds: 15));
      // if data is found, send data to a map that will be used to generate the quiz options
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Quiz data for topic $topicID: $data');
        return data
            .map<Map<String, dynamic>>((quiz) => quiz as Map<String, dynamic>)
            .toList();
      } else {
        //if no data found throw error
        throw Exception(
            'Failed to load quizzes. Status code: ${response.statusCode}');
      }
      // exception handling
    } catch (e) {
      print('Error fetching quizzes for topic $topicID: $e');
      throw Exception('Error fetching quizzes: $e');
    }
  }

  // quiz page
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
          // if no quiz data found throw error on screen
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
            // if quizes found display data into buttons genreated via list builder
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
                        // button sends you to the relavent quiz
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

// taking quiz page
class TakingQuiz extends StatefulWidget {
  // variables needed from quiz page button press
  final int quizID;
  final String quizName;
  // data is required in order to load the quiz
  TakingQuiz({required this.quizID, required this.quizName});

  @override
  TakingQuizState createState() => TakingQuizState();
}

// state stores the page as dat is laoded dynamically
class TakingQuizState extends State<TakingQuiz> {
  //page controller to update the page upon button press,
  final PageController pageController = PageController();
  //variables used to store all relaviant quiz data
  int _currentPage = 0;
  Map<int, int?> selectedAnswerId = {};
  late Future<List<Map<String, dynamic>>> futureQuestions;
  Map<String, dynamic> updatedScore = {};
  // initialise the quiz data to laod the page
  @override
  void initState() {
    super.initState();
    futureQuestions = loadQuizData();
  }

  // get the quiz data, put into file to load to cache
  Future<File> getLocalFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$filename');
  }

  // saving data to cache to be laoded dynamically, this is more efficient then loading from a file
  Future<void> saveQuizDataToCache(List<Map<String, dynamic>> data) async {
    //return nothing so error will be displayed if no data found
    if (data.isEmpty) return;
    //exception handler
    try {
      //get the file the quiz data was stored into
      final file = await getLocalFile('quiz_${widget.quizID}.json');
      await file.writeAsString(json.encode(data));
      print('Quiz ${widget.quizID} data saved to cache.');
      //exception handler
    } catch (e) {
      print('Error saving quiz data to cache: $e');
    }
  }

  // loading data from the cache
  Future<List<Map<String, dynamic>>> loadQuizDataFromCache() async {
    try {
      //get the file data
      final file = await getLocalFile('quiz_${widget.quizID}.json');
      if (await file.exists()) {
        //store file data in variable
        final contents = await file.readAsString();
        // if data in the variable, load the data
        if (contents.isNotEmpty) {
          final List<dynamic> jsonData = json.decode(contents);
          print('Quiz ${widget.quizID} data loaded from cache.');
          // store data in a map
          return jsonData
              .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
              .toList();
        }
      }
      //exception handling
    } catch (e) {
      print('Error loading quiz data from cache: $e');
    }
    return [];
  }

  // fetch the questions from database using backend function
  Future<List<Map<String, dynamic>>> fetchQuestionsFromApi() async {
    try {
      //run backend function
      final response = await http
          .get(
            Uri.parse(
                'http://localhost:8000/quiz_questions?quiz_id=${widget.quizID}'),
          )
          .timeout(const Duration(seconds: 30));
      // if data found, load data into map
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final questions = data
            .map<Map<String, dynamic>>(
                (question) => question as Map<String, dynamic>)
            .toList();
        // save the map data to the cache
        await saveQuizDataToCache(questions);
        return questions;
        //exception handling
      } else {
        throw Exception(
            'Failed to load questions and answers. Status: ${response.statusCode}');
      }
      //exception handling
    } catch (e) {
      print('Error fetching questions from API for quiz ${widget.quizID}: $e');
      throw Exception('API Error: $e');
    }
  }

  //load quiz data
  Future<List<Map<String, dynamic>>> loadQuizData() async {
    // first load data from cache
    List<Map<String, dynamic>> cachedData = await loadQuizDataFromCache();
    if (cachedData.isNotEmpty) {
      return cachedData;
    }
    //then run the function to collect data
    return fetchQuestionsFromApi();
  }

  // results dialong bog
  void showResultsDialog(int correctAnswers, int totalQuestions,
      List<Map<String, dynamic>> detailedResults) {
    //use the showDialog function to collect
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
                  // displaying collected data from show dialog
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

  //update the users score based on correct questions
  Future<void> updateTheScore(int currentUserId, int scoreAchieved) async {
    try {
      //run backend function
      final response = await http
          .post(
            Uri.parse('http://localhost:8000/update_score'),
            headers: {'Content-Type': 'application/json'},
            //send the score and user id to backend
            body: json.encode({
              'user_id': currentUserId,
              'score_achieved': scoreAchieved,
            }),
          )
          .timeout(const Duration(seconds: 15));
      // if data can be saved then announce the score has been updated in the backend
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
        //couldnt save data to user id
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
      //exception handling
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

  // submt attempts
  void submitAndCheckAnswers(List<Map<String, dynamic>> questions) async {
    //cannot submit attempts if no user id
    if (userId == null) {
      print("User ID is null. Cannot submit attempts.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Error: User not logged in. Cannot submit results.")));
      }
      return;
    }
    // variables needed to store data
    int correctAnswersCount = 0;
    List<Map<String, dynamic>> attempts = [];
    List<Map<String, dynamic>> resultsForDialog = [];
    // for every question in the possible questions
    for (var question in questions) {
      final questionId = question['question_id'] as int;
      final List<dynamic> answersList = question['answers'] as List<dynamic>;
      //variables to store the selected and correct answers
      int? selectedUserAnswerId = selectedAnswerId[questionId];
      String? userAnswerText;
      String? correctAnswerText;
      int? correctAnswerId;
      bool isUserCorrect = false;
      // check if an answer is correct
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
      // send results to dialog box
      resultsForDialog.add({
        'question_text': question['question_text'],
        'user_answer_text': userAnswerText,
        'correct_answer_text': correctAnswerText,
        'is_correct': isUserCorrect,
      });
    }
    // run backend function to submit attempts
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
        //exception handling
      } catch (e) {
        print("Error submitting attempts to backend: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("Network error submitting results: ${e.toString()}")));
        }
      }
      // if no user logged in, dont bother sending to backend as itll break
    } else if (userId == null) {
      print("User not logged in, skipping backend submission.");
      // if no atempts found, exception handle
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

  // display screen
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

// questions page
class QuestionPage extends StatelessWidget {
  // variables needed to store data
  final Map<String, dynamic> question;
  final int? selectedAnswerId;
  final Function(int) onAnswerSelected;
  final int currentPage;
  final int totalQuestions;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  // all data is required
  QuestionPage({
    required this.question,
    required this.selectedAnswerId,
    required this.onAnswerSelected,
    required this.currentPage,
    required this.totalQuestions,
    required this.onNext,
    required this.onPrevious,
  });
  //questions screen
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

// fetch quiz
Future<List<Map<String, dynamic>>> fetchQuiz(int subjectID, int topicID) async {
  try {
    //run backend function
    final response = await http.get(
      Uri.parse(
        'http://localhost:8000/quiz?subject_id=$subjectID&topic_id=$topicID',
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Quiz data (from fetchQuiz): $data');
      //store fetched data
      return data
          .map<Map<String, dynamic>>((quiz) => quiz as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load quiz (from fetchQuiz)');
    }
    //exceptino handling
  } catch (e) {
    print('Error (from fetchQuiz): $e');
    return [];
  }
}
