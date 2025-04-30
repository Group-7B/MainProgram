import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      appBar: AppBar(backgroundColor: Colors.deepOrange),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          final crossAxisCount = isWideScreen ? 2 : 1;

          return GridView.count(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3,
            children: _buildCards(context),
          );
        },
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    return [
      Card(
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/testing');
          },
          title: const Text("Maths"),
        ),
      ),
      Card(
        color: Colors.lightGreenAccent,
        child: ListTile(
          onTap: () {
            print("Clicked Chemistry");
          },
          title: const Text("Chemistry"),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () {
            print("Clicked Physics");
          },
          title: const Text("Physics"),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () {
            print("Clicked Computer Science");
          },
          title: const Text("Computer Science"),
        ),
      ),
    ];
  }
}

class TestingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepOrange),
      body: Center(child: Text("New page testing")),
    );
  }
}
