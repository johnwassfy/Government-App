class Message {
  final String senderId;
  final String senderEmail;
  final String content;
  final String? subject;
  final String? reply;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.content,
    this.subject,
    this.reply,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'content': content,
      'subject': subject,
      'reply': reply,
    };
  }
}
