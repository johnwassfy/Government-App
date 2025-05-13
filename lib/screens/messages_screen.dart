import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/services/message_service.dart';
import 'package:project/models/message.dart';

class MessagesScreen extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  MessagesScreen({super.key});

  void _sendMessage(BuildContext context) async {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not logged in")));
        return;
      }

      final message = Message(
        senderId: user.uid,
        senderEmail: user.email ?? '',
        content: content,
      );

      await MessageService().sendMessage(message);

      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message sent")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Message")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Enter your message",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _sendMessage(context),
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
