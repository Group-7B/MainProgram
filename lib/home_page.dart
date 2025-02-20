import 'package:flutter/material.dart';

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
          title: const Text("Maths"),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () {
            print("Clicked Chemistry");
          },
          title:const Text("Chemistry and computing "),
        ),
      ),
      Card(
        child: ListTile(
          onTap: () {
            print("Clicked Physics");
          },
          title:const Text("Physics"),
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
