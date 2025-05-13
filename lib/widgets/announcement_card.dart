// widgets/announcement_card.dart
import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import 'package:intl/intl.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().add_jm().format(announcement.createdAt.toDate());

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(announcement.announcement),
        subtitle: Text("Published on $date"),
        leading: Icon(Icons.announcement),
      ),
    );
  }
}
