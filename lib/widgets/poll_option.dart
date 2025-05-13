import 'package:flutter/material.dart';

class PollOption extends StatelessWidget {
  final String question;
  final List<String> options;
  final Function(String) onVote;

  const PollOption({
    required this.question,
    required this.options,
    required this.onVote,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...options.map((option) {
              return ListTile(
                title: Text(option),
                trailing: const Icon(Icons.check_circle_outline),
                onTap: () {
                  onVote(option);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You voted for: $option')),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
