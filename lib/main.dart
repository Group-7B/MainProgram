import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          final crossAxisCount = isWideScreen ? 2 : 1;

          return GridView.count(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3,
            children: _buildCards(),
          );
        },
      ),
    );
  }

  List<Widget> _buildCards() {
    return [
      Card(
        child: ListTile(
          onTap: () {
            print('Card tapped');
          },
          title: Text("Maths"),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () {
            print("Clicked Chemistry");
          },
          title: Text("Chemistry"),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () {
            print("Clicked Physics");
          },
          title: Text("Physics"),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () {
            print("Clicked Computer Science");
          },
          title: Text("Computer Science"),
        ),
      ),
    ];
  }
}
