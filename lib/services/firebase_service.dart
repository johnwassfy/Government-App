import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/models/announcement_model.dart';
import 'package:project/models/comment_model.dart';
import 'package:project/models/advertisement_model.dart'; // <-- Add this import
import 'package:intl/intl.dart';

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


    // --------- PHONE NUMBERS ---------

  Stream<List<Map<String, dynamic>>> getOfficialPhoneNumbersStream() {
    return _db
        .collection('official_phone_numbers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'description': data['description'] ?? '',
                'number': data['number'] ?? '',
              };
            }).toList());
  }

  Future<void> addPhoneNumber(String description, String number) async {
    await _db.collection('official_phone_numbers').add({
      'description': description,
      'number': number,
    });
  }

  Future<void> updatePhoneNumber(String id, String description, String number) async {
    await _db.collection('official_phone_numbers').doc(id).update({
      'description': description,
      'number': number,
    });
  }

  Future<void> deletePhoneNumber(String id) async {
    await _db.collection('official_phone_numbers').doc(id).delete();
  }

    // =============== MESSAGING FUNCTIONALITY ===============

  // Get the chat document reference for a citizen
  DocumentReference getCitizenChatDoc(String userId) {
    return _db.collection('chats').doc('government_citizen_$userId');
  }

  // Send a message to/from government
  Future<void> sendMessage(String userId, String text, bool isGovernment) async {
    try {
      final chatRef = _db.collection('chats').doc('government_citizen_$userId');
      
      // Create the message data
      final messageData = {
        'text': text,
        'sender': isGovernment ? 'government' : userId,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      };

      // Create the chat document if it doesn't exist
      await _db.runTransaction((transaction) async {
        // Get the current document
        final doc = await transaction.get(chatRef);
        
        if (!doc.exists) {
          // Create new chat document
          transaction.set(chatRef, {
            'participants': ['government', userId],
            'createdAt': FieldValue.serverTimestamp(),
            'lastMessage': text,
            'lastMessageTime': FieldValue.serverTimestamp(),
          });
        } else {
          // Update existing chat document
          transaction.update(chatRef, {
            'lastMessage': text,
            'lastMessageTime': FieldValue.serverTimestamp(),
          });
        }
        
        // Add the new message
        transaction.set(chatRef.collection('messages').doc(), messageData);
      });
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }
  // Get messages stream for a citizen
  Stream<QuerySnapshot> getMessagesStream(String userId) {
    return getCitizenChatDoc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Format timestamp for display
  String formatMessageTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('h:mm a').format(date);
  }

  // Add these methods to your FirebaseService class

  // Get all chats with citizens
  Stream<QuerySnapshot> getAllChatsStream() {
    return _db.collection('chats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Get user data for a chat
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.data() ?? {'name': 'Unknown User'};
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId) async {
    final messages = await _db.collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('read', isEqualTo: false)
        .where('sender', isNotEqualTo: 'government')
        .get();

    final batch = _db.batch();
    for (var doc in messages.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  // Get unread message count for admin
  Stream<int> getUnreadMessageCount() {
    return _db.collection('chats')
        .snapshots()
        .asyncMap((snapshot) async {
          int total = 0;
          for (var doc in snapshot.docs) {
            final unread = await _db.collection('chats')
                .doc(doc.id)
                .collection('messages')
                .where('read', isEqualTo: false)
                .where('sender', isNotEqualTo: 'government')
                .get();
            total += unread.size;
          }
        return total;
      }
    );
  }
}
