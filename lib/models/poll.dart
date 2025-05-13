class Poll {
  final String id;
  final String question;
  final List<String> options;
  final Map<String, int> votes; // option -> number of votes
  final bool isActive;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.votes,
    required this.isActive,
  });

  // Convert a Poll object to a Map (useful for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'votes': votes,
      'isActive': isActive,
    };
  }

  // Create a Poll object from a Map (e.g. from Firebase)
  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      votes: Map<String, int>.from(map['votes'] ?? {}),
      isActive: map['isActive'] ?? true,
    );
  }
}
