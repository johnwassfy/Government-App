import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/models/report.dart'; 

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Report>> getAllReports() async {
    try {
      final querySnapshot = await _firestore.collection('reports').get();
      final reports = querySnapshot.docs.map((doc) {
        return Report.fromMap(doc.data());
      }).toList();
      return reports;
    } catch (e) {
      throw Exception("Failed to load reports: $e");
    }
  }

  /// Create a new report
  Future<void> createReport({
    required String title,
    required String description,
    required List<String> items,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final report = Report(
        id: _firestore.collection('reports').doc().id, // Auto-generate ID
        title: title,
        description: description,
        items: items,
      );

      // Add report to Firestore
      await _firestore.collection('reports').doc(report.id).set(report.toMap());
    } catch (e) {
      throw Exception("Failed to create report: $e");
    }
  }

  /// Update an existing report
  Future<void> updateReport({
    required String reportId,
    required String title,
    required String description,
    required List<String> items,
  }) async {
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'title': title,
        'description': description,
        'items': items,
      });
    } catch (e) {
      throw Exception("Failed to update report: $e");
    }
  }

  /// Delete a report by ID
  Future<void> deleteReport(String reportId) async {
    try {
      await _firestore.collection('reports').doc(reportId).delete();
    } catch (e) {
      throw Exception("Failed to delete report: $e");
    }
  }
}
