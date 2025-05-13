class Report {
  final String id;
  final String title;
  final String description;
  final List<String> items;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
  });

  // Convert Firestore document data to a Report object
  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      items: List<String>.from(map['items'] ?? []),
    );
  }

  // Convert Report object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'items': items,
    };
  }
}
