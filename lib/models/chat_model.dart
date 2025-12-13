import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id, text;
  final DateTime time;
  final bool isMe;
  final String? authorId;

  ChatMessage({
    required this.id, required this.text, required this.time,
    required this.isMe, this.authorId
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
        id: doc.id,
        text: data['text'] ?? '',
        time: (data['time'] as Timestamp).toDate(),
        isMe: data['isMe'] ?? false,
        authorId: data['authorId']
    );
  }

  Map<String, dynamic> toFirestore() => {
    'text': text,
    'time': Timestamp.fromDate(time),
    'isMe': isMe,
    'authorId': authorId
  };
}

class ChatThread {
  final String id, title;
  final DateTime? createdAt;

  ChatThread({required this.id, required this.title, this.createdAt});

  factory ChatThread.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatThread(
        id: doc.id,
        title: data['title'] ?? 'Без назви',
        createdAt: data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate() : null
    );
  }
}
