import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/models/message.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send a message to the government from a citizen
  Future<void> sendMessageToGov({
    required String subject,
    required String content,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _firestore.collection('messages').add({
      'senderId': user.uid,
      'senderEmail': user.email,
      'subject': subject,
      'content': content,
      'reply': null,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Generic message submission using Message model
  Future<void> sendMessage(Message message) async {
    await _firestore.collection('messages').add({
      ...message.toMap(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Get all messages sent by the current user (for citizens)
  Stream<QuerySnapshot> getUserMessages() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection('messages')
        .where('senderId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Get all incoming messages (for government admin)
  Stream<QuerySnapshot> getAllMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Reply to a message (for government admin)
  Future<void> replyToMessage(String messageId, String replyText) async {
    await _firestore.collection('messages').doc(messageId).update({
      'reply': replyText,
      'repliedAt': FieldValue.serverTimestamp(),
    });
  }
}
