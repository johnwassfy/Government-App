import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/announcement.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all announcements
  Future<List<Announcement>> fetchAnnouncements() async {
    try {
      final snapshot = await _db.collection('announcements').get();
      return snapshot.docs.map((doc) {
        return Announcement.fromMap(doc.data());
      }).toList();
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
}
