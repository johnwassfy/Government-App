// lib/screens/admin_screen.dart
import 'package:flutter/material.dart';
import 'package:project/widgets/announcement_tile.dart'; // Announcement tile for viewing/editing

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Logic to create new announcement
              },
              child: Text("Create Announcement"),
            ),
            SizedBox(height: 20),
            Text('Manage Announcements:', style: TextStyle(fontSize: 22)),
            AnnouncementTile(announcement: 'ايها الجماهير العريضة',),
          ],
        ),
      ),
    );
  }
}
