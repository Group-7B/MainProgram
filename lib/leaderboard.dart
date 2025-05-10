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
  State<Leaderboard> createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  late Future<List<LeaderboardEntry>> leaderboardData;

  @override
  void initState() {
    super.initState();
    leaderboardData = loadLeaderboard();
  }

  Future<List<LeaderboardEntry>> loadLeaderboard() async {
    final Uri leaderboardUrl = Uri.parse('http://localhost:8000/leaderboard');
    try {
      final response =
          await http.get(leaderboardUrl).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        List<LeaderboardEntry> entries = jsonList
            .map((jsonItem) =>
                LeaderboardEntry.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        entries.sort((a, b) => b.score.compareTo(a.score));
        return entries;
      } else {
        print(
            'Failed to load leaderboard. Status: ${response.statusCode}, Body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error loading leaderboard data from server: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
      ),
      body: Center(
        child: FutureBuilder<List<LeaderboardEntry>>(
          future: leaderboardData,
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
