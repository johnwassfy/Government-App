// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:project/widgets/announcement_tile.dart'; // For displaying announcements
import 'package:project/widgets/poll_option.dart'; // For displaying poll options

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Announcements Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Announcements', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            AnnouncementTile(announcement: 'New bridge construction starts next week!'),
            
            // Poll Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Poll: Suggest a new Bridge', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            PollOption(
              question: 'What do you think about the new bridge construction?',
              options: ['Good', 'Bad', 'Neutral'],
              onVote: (String option) {
                print('User voted for: $option');
              },
            ),
          ],
        ),
      ),
    );
  }
}
