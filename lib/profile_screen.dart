import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:convert';

class ProfileEntry {
  final String name;
  final String email;
  final int score;

// data type to store the profile information into
  ProfileEntry({required this.name, required this.email, required this.score});
  factory ProfileEntry.fromJson(Map<String, dynamic> json) {
    return ProfileEntry(
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'Unknown',
      score: json['score'] ?? 0,
    );
  }
}

//screen to display data
class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({required this.userId, super.key});
  @override
  State<ProfileScreen> createState() => ProfileState();
}

// state stores page information, allows for updates to happen has it is generated
class ProfileState extends State<ProfileScreen> {
  late Future<ProfileEntry> profileData;
  @override
  void initState() {
    super.initState();
    profileData = loadProfile(widget.userId);
  }

// function to fetch profile data via the users user id
  Future<ProfileEntry> loadProfile(int userId) async {
    // connecting to database through http
    final Uri profileUrl =
        Uri.parse('http://localhost:8000/profile?user_id=$userId');
    print('Fetching profile from: $profileUrl');
    try {
      final response =
          await http.get(profileUrl).timeout(const Duration(seconds: 10));
      print('Response status: ${response.statusCode}');
      // if data is found, save it
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return ProfileEntry.fromJson(jsonResponse);
        //if user id isnt found, through error
      } else if (response.statusCode == 404) {
        print('Profile not found for user ID: $userId');
        throw Exception('Profile not found');
        //any other error that can happen through http
      } else {
        print('Failed to load profile. Status: ${response.statusCode}');
        throw Exception(
            'Failed to load profile data (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching profile for user ID $userId: $e');
      throw Exception('Could not fetch profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ('Profile'),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 23, 118, 13),
      ),
      // body is the profile entry class so data can be used
      body: FutureBuilder<ProfileEntry>(
        future: profileData,
        builder: (context, snapshot) {
          // if data isnto found, display an error message
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading profile: ${snapshot.error}\nPlease try again later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
            // if data is found then generate the site
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile.png'),
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'User',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ProfileItem(Icons.email, profile.email),
                    ProfileItem(
                        Icons.score, 'Overall Progress: ${profile.score}'),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No profile data available.'));
          }
        },
      ),
    );
  }

// widget used outsite to allow for the fetched data to be inputted, program wont load if this code was in the scaffold
  Widget ProfileItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Theme.of(context).primaryColorDark),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
