import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:convert';

class LeaderboardEntry {
  final String name;
  final int score;

  LeaderboardEntry({required this.name, required this.score});
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      name: json['name'] ?? 'Unknown',
      score: json['score'] ?? 0,
    );
  }
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late Future<List<LeaderboardEntry>> _leaderboardDataFuture;

  @override
  void initState() {
    super.initState();
    // Start loading the JSON data when the widget is first created
    _leaderboardDataFuture = _loadLeaderboardData();
  }

  Future<List<LeaderboardEntry>> _loadLeaderboardData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/leaderboard_data.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);

      List<LeaderboardEntry> entries = jsonList
          .map((jsonItem) =>
              LeaderboardEntry.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
      entries.sort((a, b) => b.score.compareTo(a.score));
      return entries;
    } catch (e) {
      print('Error loading or parsing leaderboard data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
      ),
      body: Center(
        child: FutureBuilder<List<LeaderboardEntry>>(
          future: _leaderboardDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final leaderboardEntries = snapshot.data!;

              if (leaderboardEntries.isEmpty) {
                return const Center(child: Text('No leaderboard data found.'));
              }

              return ListView.builder(
                itemCount: leaderboardEntries.length,
                itemBuilder: (context, index) {
                  final entry = leaderboardEntries[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    color: const Color.fromARGB(255, 49, 107, 51),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${index + 1}.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.name,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${entry.score} pts',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        ),
      ),
    );
  }
}
