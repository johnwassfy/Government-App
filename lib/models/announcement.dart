class Announcement {
  final String title;
  final String description;
  final String date;
  final String fileUrl;
  final String imageUrl;

  Announcement({
    required this.title,
    required this.description,
    required this.date,
    required this.fileUrl,
    required this.imageUrl,
  });

  factory Announcement.fromMap(Map<String, dynamic> data) {
    return Announcement(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'fileUrl': fileUrl,
      'imageUrl': imageUrl,
    };
  }
}
