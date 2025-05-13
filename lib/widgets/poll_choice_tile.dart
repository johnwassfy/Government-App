import 'package:flutter/material.dart';

class PollChoiceTile extends StatelessWidget {
  final String option;
  final int voteCount;
  final bool isSelected;
  final VoidCallback onTap;

  const PollChoiceTile({
    required this.option,
    required this.voteCount,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.shade100 : Colors.white,
      child: ListTile(
        title: Text(option),
        subtitle: Text('$voteCount votes'),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
        onTap: onTap,
      ),
    );
  }
}
