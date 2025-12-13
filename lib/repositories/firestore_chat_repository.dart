import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class FirestoreChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // СПИСОК ЧАТІВ
  Stream<List<ChatThread>> getChats() =>
      _firestore.collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => ChatThread.fromFirestore(doc))
          .toList());

  // ПОВІДОМЛЕННЯ В ЧАТІ
  Stream<List<ChatMessage>> getMessages(String chatId) =>
      _firestore.collection('chats').doc(chatId)
          .collection('messages')
          .orderBy('time')
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList());

  // СТВОРЕННЯ ЧАТУ
  Future<void> createChat(String title) async {
    await _firestore.collection('chats').add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp()
    });
  }

  // НАДІСЛАТИ ПОВІДОМЛЕННЯ
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await _firestore.collection('chats').doc(chatId)
        .collection('messages').add(message.toFirestore());
  }

  // ОНОВИТИ НАЗВУ ЧАТУ (для редагування)
  Future<void> updateChatTitle(String chatId, String newTitle) async {
    await _firestore.collection('chats').doc(chatId).update({
      'title': newTitle
    });
  }

  // ВИДАЛИТИ ПОВІДОМЛЕННЯ
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore.collection('chats').doc(chatId)
        .collection('messages').doc(messageId).delete();
  }
}
