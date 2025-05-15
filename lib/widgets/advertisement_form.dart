import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/advertisement_model.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdvertisementForm extends StatefulWidget {
  @override
  _AdvertisementFormState createState() => _AdvertisementFormState();
}

class _AdvertisementFormState extends State<AdvertisementForm> {
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
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submitAd() async {
    if (_subjectController.text.isEmpty || _descController.text.isEmpty) return;

    final ad = Advertisement(
      id: const Uuid().v4(),
      subject: _subjectController.text,
      description: _descController.text,
      imagePath: _selectedImage?.path,
      createdBy: currentUser ?? FirebaseFirestore.instance.collection('users').doc('unknown_user'),
      createdAt: Timestamp.now(),
      isApproved: false,
      reason: 'null',
    );

    await _firebaseService.addAdvertisement(ad);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // for keyboard
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create New Ad', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 12),
            _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_selectedImage!, height: 160, fit: BoxFit.cover),
                  )
                : OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image_outlined),
                    label: Text('Upload Image'),
                  ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitAd,
              icon: Icon(Icons.check_circle),
              label: Text('Submit Advertisement'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
