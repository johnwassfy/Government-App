import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficialPhoneNumbersSection extends StatelessWidget {
  const OfficialPhoneNumbersSection({super.key});

  Future<void> _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('official_phone_numbers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("Error loading phone numbers.");
        if (!snapshot.hasData) return CircularProgressIndicator();

        final docs = snapshot.data!.docs;

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final description = data['description'] ?? '';
            final number = data['number'] ?? '';

            return ListTile(
              title: Text(description, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(number),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.green),
                onPressed: () => _callNumber(number),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
