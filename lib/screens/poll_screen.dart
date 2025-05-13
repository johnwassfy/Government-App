import 'package:flutter/material.dart';
import 'package:project/models/poll.dart';
import 'package:project/widgets/poll_choice_tile.dart';

class PollScreen extends StatefulWidget {
  final Poll poll;

  const PollScreen({required this.poll, super.key});

  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    final poll = widget.poll;

    return Scaffold(
      appBar: AppBar(title: Text(poll.question)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (var option in poll.options)
              PollChoiceTile(
                option: option,
                voteCount: poll.votes[option] ?? 0,
                isSelected: selectedOption == option,
                onTap: () {
                  setState(() {
                    selectedOption = option;
                  });
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedOption == null
                  ? null
                  : () {
                      // TODO: Implement vote submission logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Voted for "$selectedOption"')),
                      );
                    },
              child: const Text("Submit Vote"),
            ),
          ],
        ),
      ),
    );
  }
}
