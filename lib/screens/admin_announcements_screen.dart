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
        title: Text('Manage Announcements', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 28),
            onPressed: () => _showEditForm(),
            tooltip: 'Create new announcement',
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('announcements')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ));
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.announcement, size: 48, color: Colors.blue.shade300),
                    SizedBox(height: 16),
                    Text('No announcements yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('Tap the + button to create one',
                        style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: docs.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (_, index) {
                final doc = docs[index];
                final announcement = Announcement.fromJson(
                    doc.data() as Map<String, dynamic>, doc.id);

                return Dismissible(
                  key: ValueKey(announcement.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.white)),
                      ],
                    ),
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
                      await _firebaseService.deleteAnnouncement(announcement.id); 
                      return true;
                    }
                    return false;
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _viewComments(announcement),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    announcement.subject,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showEditForm(existing: announcement),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              announcement.announcement,
                              style: TextStyle(fontSize: 16),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _formatDate(announcement.createdAt.toDate()),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
