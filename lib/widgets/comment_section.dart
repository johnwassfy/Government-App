// widgets/comment_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/comment_model.dart';
import '../services/firebase_service.dart';

class CommentSection extends StatefulWidget {
  final String parentType;
  final String parentId;
  final String? currentUserId;

  const CommentSection({
    required this.parentType,
    required this.parentId,
    required this.currentUserId,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _controller = TextEditingController();
  bool _isAnonymous = false;

  @override
  Widget build(BuildContext context) {
    final service = FirebaseService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<List<Comment>>(
          stream: service.fetchComments(widget.parentType, widget.parentId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            final comments = snapshot.data!;
            if (comments.isEmpty) return Text("No comments yet.");

            return Column(
  children: comments.map((comment) {
    return FutureBuilder<String>(
      future: comment.isAnonymous
          ? Future.value('Anonymous Member')
          : service.getUserFullName(comment.createdBy ?? ''),
      builder: (context, userSnapshot) {
        final name = userSnapshot.data ?? 'Loading...';

        return ListTile(
          title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(comment.content),
          trailing: Text(
            DateFormat('yyyy-MM-dd – kk:mm').format(comment.createdAt),
            style: TextStyle(fontSize: 12),
          ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),

        Divider(),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Write a comment...'),
              ),
            ),
            Checkbox(
              value: _isAnonymous,
              onChanged: (val) => setState(() => _isAnonymous = val!),
            ),
            Text('Anon'),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (_controller.text.trim().isEmpty) return;

                final comment = Comment(
                  id: '',
                  content: _controller.text.trim(),
                  createdAt: DateTime.now(),
                  createdBy: _isAnonymous ? null : widget.currentUserId,
                  isAnonymous: _isAnonymous,
                  parentType: widget.parentType,
                  parentId: widget.parentId,
                );

                await service.addComment(comment);
                _controller.clear();
              },
            ),
          ],
        ),
      ],
    );
  }
}
