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
  late Future<List<LeaderboardEntry>> _leaderboardData;

  @override
  void initState() {
    super.initState();
    // Start loading the JSON data when the widget is first created
    _leaderboardData = _loadLeaderboard();
  }

  Future<List<LeaderboardEntry>> _loadLeaderboard() async {
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
      print('Error loading leaderboard data: $e');
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
          future: _leaderboardData,
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
                  // create a new widget seperately to get images or number positions, works as a function within the listbuilder
                  Widget positionWidget;
                  const double medalSize = 28.0;
                  final TextStyle rankTextStyle = const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white);
                  final fallbackEmojiStyle =
                      TextStyle(fontSize: medalSize * 0.8);
                  // Check for ranks 4+ first for efficiency
                  if (index >= 3) {
                    positionWidget = Text(
                      '${index + 1}',
                      style: rankTextStyle,
                      textAlign: TextAlign.center,
                    );
                  } else if (index == 0) {
                    positionWidget = Image.asset(
                      'assets/goldmedal.png',
                      height: medalSize,
                      width: medalSize,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Text('🥇', style: fallbackEmojiStyle),
                    );
                  } else if (index == 1) {
                    positionWidget = Image.asset(
                      'assets/silvermedal.png',
                      height: medalSize,
                      width: medalSize,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Text('🥈', style: fallbackEmojiStyle),
                    );
                  } else {
                    positionWidget = Image.asset(
                      'assets/bronzemedal.png',
                      height: medalSize,
                      width: medalSize,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Text('🥉', style: fallbackEmojiStyle),
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 49, 107, 51),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: positionWidget,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.name,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${entry.score} pts',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
