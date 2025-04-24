import 'package:flutter/material.dart';
import 'package:social_media_app/features/chat/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repository/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _repository.getMessages(chatId);
  }

  Future<void> sendMessage(
    String chatId,
    String senderId,
    String receiverId,
    String messageText,
  ) async {
    final messageId =
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc()
            .id;
    final message = MessageModel(
      id: messageId,
      senderId: senderId,
      receiverId: receiverId,
      message: messageText,
      timestamp: DateTime.now(),
    );
    await _repository.sendMessage(chatId, message);
  }

  Stream<List<Map<String, dynamic>>> getUserChats(String userId) {
    return _repository.getUserChats(userId);
  }

  Future<Map<String, dynamic>> getUserData(String uid) {
    return _repository.getUserData(uid);
  }
  



}
