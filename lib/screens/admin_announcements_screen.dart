import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'announcement_detail_screen.dart';

import '../services/firebase_service.dart';
import '../models/announcement_model.dart';

class AdminAnnouncementsScreen extends StatefulWidget {
  @override
  _AdminAnnouncementsScreenState createState() =>
      _AdminAnnouncementsScreenState();
}

class _AdminAnnouncementsScreenState extends State<AdminAnnouncementsScreen> {
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _uploadAnnouncement({String? docId}) async {
    if (_subjectController.text.isEmpty || _bodyController.text.isEmpty) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to post an announcement')));
      return;
    }

    final createdByRef =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);

    final announcement = Announcement(
      id: docId ?? '',
      subject: _subjectController.text,
      announcement: _bodyController.text,
      createdAt: Timestamp.now(),
      createdBy: createdByRef,
    );

    if (docId != null) {
      await _firebaseService.updateAnnouncement(docId, announcement);
    } else {
      await _firebaseService.addAnnouncement(announcement);
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Announcement posted!')));
    _subjectController.clear();
    _bodyController.clear();
    Navigator.of(context).pop(); // close bottom sheet if open
  }

  void _showEditForm({Announcement? existing}) {
    if (existing != null) {
      _subjectController.text = existing.subject;
      _bodyController.text = existing.announcement;
    } else {
      _subjectController.clear();
      _bodyController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(existing == null ? 'New Announcement' : 'Edit Announcement'),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'Announcement'),
              maxLines: 6,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _uploadAnnouncement(docId: existing?.id),
              child: Text(existing == null ? 'Post' : 'Update'),
            )
          ],
        ),
      ),
    );
  }


  void _viewComments(Announcement announcement) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AnnouncementDetailScreen(
          announcement: announcement,
          allowCommenting: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showEditForm(),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('announcements')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No announcements posted yet.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, index) {
              final doc = docs[index];
              final announcement = Announcement.fromJson(doc.data() as Map<String, dynamic>, doc.id);

              return Dismissible(
                key: ValueKey(announcement.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Delete Announcement'),
                      content: Text('Are you sure you want to delete this announcement?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                      ],
                    ),
                  );

                  if (shouldDelete == true) {
                    await _firebaseService.deleteAnnouncement(announcement.id); // ✅ This is fine
                    return true; // ✅ This boolean is returned explicitly
                  }

                  return false;
                },

                child: ListTile(
                  title: Text(announcement.subject, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(announcement.announcement),
                  onTap: () => _viewComments(announcement),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditForm(existing: announcement),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
