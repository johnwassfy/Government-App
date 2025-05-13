import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String subject;
  final String announcement;
  final Timestamp createdAt;
  final DocumentReference createdBy;

  Announcement({
    required this.id,
    required this.subject,
    required this.announcement,
    required this.createdAt,
    required this.createdBy,
  });

  // From Firestore
  factory Announcement.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      subject: data['subject'] ?? '',
      announcement: data['announcement'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'],
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'announcement': announcement,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }

  factory Announcement.fromJson(Map<String, dynamic> json, String id) {
  return Announcement(
    id: id,
    subject: json['subject'] ?? '',
    announcement: json['announcement'] ?? '',
    createdAt: json['createdAt'] ?? Timestamp.now(),
    createdBy: json['createdBy'],
  );
}
}
