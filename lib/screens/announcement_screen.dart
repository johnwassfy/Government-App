// lib/screens/announcement_screen.dart
import 'package:flutter/material.dart';
import 'package:project/models/announcement.dart'; // Announcement model

class AnnouncementScreen extends StatelessWidget {
  final Announcement announcement;

  AnnouncementScreen({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(announcement.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(announcement.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            announcement.fileUrl.isNotEmpty
                ? ElevatedButton(
                    onPressed: () {
                      // Open file (PDF, image, etc.)
                    },
                    child: Text("View attached file"),
                  )
                : Container(),
            SizedBox(height: 10),
            announcement.imageUrl.isNotEmpty
                ? Image.network(announcement.imageUrl)
                : Container(),
          ],
        ),
      ),
    );
  }
}
