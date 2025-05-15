import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/advertisement_model.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAdvertisementScreen extends StatefulWidget {
  @override
  _CreateAdvertisementScreenState createState() => _CreateAdvertisementScreenState();
}

class _CreateAdvertisementScreenState extends State<CreateAdvertisementScreen> {
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();
  final _firebaseService = FirebaseService();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  DocumentReference? currentUser;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (currentUserId != null) {
      currentUser = FirebaseFirestore.instance.collection('users').doc(currentUserId);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _submitAd() async {
    if (_subjectController.text.isEmpty || _descController.text.isEmpty) return;

    final ad = Advertisement(
      id: const Uuid().v4(),
      subject: _subjectController.text,
      description: _descController.text,
      imagePath: _selectedImage?.path, // optionally add upload to storage
      createdBy: currentUser ?? FirebaseFirestore.instance.collection('users').doc('unknown_user'), // Replace with actual user ID logic
      createdAt: Timestamp.now(),
      isApproved: false, // Default value
      reason: 'null', // Default value
    );

    await _firebaseService.addAdvertisement(ad);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Advertisement')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150)
                : TextButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
            Spacer(),
            ElevatedButton(onPressed: _submitAd, child: Text('Submit')),
          ],
        ),
      ),
    );
  }
}
