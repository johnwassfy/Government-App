import 'package:cloud_firestore/cloud_firestore.dart';

class Advertisement {
  final String id;
  final String subject;
  final String description;
  final String? imagePath; // local path
  final DocumentReference createdBy;
  final Timestamp createdAt;
  final bool isApproved;
  final String reason;

  Advertisement({
    required this.id,
    required this.subject,
    required this.description,
    this.imagePath,
    required this.createdBy,
    required this.createdAt,
    required this.isApproved,
    required this.reason,
  });

  // Factory constructor to create an instance from a Map
  factory Advertisement.fromJson(Map<String, dynamic> data) {
    return Advertisement(
      id: data['id'] ?? '', // Make sure to handle null or missing fields
      subject: data['subject'] ?? '',
      description: data['description'] ?? '',
      imagePath: data['imagePath'],
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      isApproved: data['isApproved'] ?? false, // Default value
      reason: data['reason'] == 'null' ? '' : data['reason'] ?? '',
    );
  }

  // Method to convert the instance to a Map (for serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'imagePath': imagePath,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'isApproved': isApproved,
      'reason': reason,
    };
  }
}
