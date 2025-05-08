import 'package:flutter/material.dart';

class RewardScreen extends StatelessWidget {
  final int marks;

  const RewardScreen({super.key, required this.marks});

  String getReward() {
    if (marks >= 90) {
      return 'Gold';
    } else if (marks >= 75) {
      return 'Silver';
    } else if (marks >= 50) {
      return 'Bronze';
    } else {
      return 'No Reward';
    }
  }

  @override
  Widget build(BuildContext context) {
    final reward = getReward();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reward'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Marks: $marks',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              'Reward: $reward',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: reward == 'Gold'
                    ? Colors.amber
                    : reward == 'Silver'
                        ? Colors.grey
                        : reward == 'Bronze'
                            ? Colors.brown
                            : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
