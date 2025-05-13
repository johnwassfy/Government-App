import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/announcement_model.dart';
import 'package:project/models/comment_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addComment(Comment comment) async {
    await _db.collection('comments').add(comment.toMap());
  }

  // Fetch all announcements
  Future<List<Announcement>> fetchAnnouncements() async {
    try {
      final snapshot = await _db.collection('announcements').get();
      return snapshot.docs.map((doc) => Announcement.fromMap(doc)).toList();
    } catch (e) {
      throw Exception("Failed to load announcements: $e");
    }
  }

  // Add a new announcement
  Future<void> addAnnouncement(Announcement announcement) async {
    try {
      await _db.collection('announcements').add(announcement.toMap());
    } catch (e) {
      throw Exception("Failed to add announcement: $e");
    }
  }

  Stream<List<Comment>> fetchComments(String parentType, String parentId) {
    return _db
        .collection('comments')
        .where('parentType', isEqualTo: parentType)
        .where('parentId', isEqualTo: parentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<String> getUserFullName(String userId) async {
  try {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists && doc.data() != null) {
      return doc.data()!['name'] ?? 'Unknown User';
    }
    return 'Unknown User';
  } catch (e) {
    return 'Unknown User';
  }
}

  Future<void> updateAnnouncement(String id, Announcement announcement) async {
    await _db.collection('announcements').doc(id).update(announcement.toMap());
  }

  Future<void> deleteAnnouncement(String id) async {
    await _db.collection('announcements').doc(id).delete();
  }

  Stream<List<Announcement>> getAnnouncementsStream() {
    return _db.collection('announcements')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Announcement.fromMap(doc))
            .toList());
  }

}
