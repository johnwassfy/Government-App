import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/models/announcement_model.dart';
import 'package:project/models/comment_model.dart';
import 'package:project/models/advertisement_model.dart'; // <-- Add this import

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------- COMMENTS ----------------

  Future<void> addComment(Comment comment) async {
    await _db.collection('comments').add(comment.toMap());
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

  // ---------------- ANNOUNCEMENTS ----------------

  Future<List<Announcement>> fetchAnnouncements() async {
    try {
      final snapshot = await _db.collection('announcements').get();
      return snapshot.docs.map((doc) => Announcement.fromMap(doc)).toList();
    } catch (e) {
      throw Exception("Failed to load announcements: $e");
    }
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    try {
      await _db.collection('announcements').add(announcement.toMap());
    } catch (e) {
      throw Exception("Failed to add announcement: $e");
    }
  }

  Future<void> updateAnnouncement(String id, Announcement announcement) async {
    await _db.collection('announcements').doc(id).update(announcement.toMap());
  }

  Future<void> deleteAnnouncement(String id) async {
    await _db.collection('announcements').doc(id).delete();
  }

  Stream<List<Announcement>> getAnnouncementsStream() {
    return _db
        .collection('announcements')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Announcement.fromMap(doc))
            .toList());
  }

  // ---------------- ADVERTISEMENTS ----------------

  Future<void> addAdvertisement(Advertisement ad) async {
    await _db.collection('advertisements').add(ad.toJson()); // Changed to toJson
  }

  Future<List<Advertisement>> fetchAdvertisements() async {
    final snapshot = await _db
        .collection('advertisements')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Advertisement.fromJson(doc.data())) // Changed to fromJson
        .toList();
  }

  Stream<List<Advertisement>> getApprovedAdvertisementsStream() {
  return _db
      .collection('advertisements')
      .where('isApproved', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Advertisement.fromJson(doc.data()))
          .toList());
  }


  Stream<List<Advertisement>> getAdvertisementsStream() {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid == null) {
    // Return empty stream if no user is logged in
    return Stream.value([]);
  }
  return _db
      .collection('advertisements')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Advertisement.fromJson(doc.data()))
          .toList());
}

Future<void> deleteAdvertisement(String id) async {
  try {
    await _db.collection('advertisements').doc(id).delete();
  } catch (e) {
    print('Failed to delete advertisement: $e');
  }
}
  Future<void> updateAdvertisement(String id, Advertisement ad) async {
    await _db.collection('advertisements').doc(id).update(ad.toJson()); // Changed to toJson
  }
}
