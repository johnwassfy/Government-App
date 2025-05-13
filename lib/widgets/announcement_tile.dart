// lib/widgets/announcement_tile.dart

import 'package:flutter/material.dart';

class AnnouncementTile extends StatelessWidget {
  final String announcement;

  const AnnouncementTile({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          announcement,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Icon(Icons.info_outline),
        onTap: () {
          // Handle tap, maybe navigate to a detailed announcement screen
        },
      ),
    );
  }
}
