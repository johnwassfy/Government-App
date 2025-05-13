import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/announcement_model.dart';
import '../widgets/comment_section.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;
  final bool allowCommenting;

  AnnouncementDetailScreen({
    required this.announcement,
    this.allowCommenting = true,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().add_jm().format(announcement.createdAt.toDate());
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Announcement')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.subject,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Posted on $formattedDate', style: TextStyle(color: Colors.grey)),
              Divider(height: 32),
              Text(
                announcement.announcement,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              if (allowCommenting) ...[
                Text(
                  'Comments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CommentSection(
                  parentType: 'announcement',
                  parentId: announcement.id,
                  currentUserId: currentUser?.uid,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
