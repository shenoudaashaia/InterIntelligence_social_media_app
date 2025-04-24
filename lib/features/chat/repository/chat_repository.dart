import 'package:social_media_app/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:social_media_app/features/chat/data/model/message_model.dart';

class ChatRepository {
  final ChatRemoteDataSource _remoteDataSource = ChatRemoteDataSource();

  Future<void> sendMessage(String chatId, MessageModel message) {
    return _remoteDataSource.sendMessage(chatId, message);
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _remoteDataSource.getMessages(chatId);
  }
  Stream<List<Map<String, dynamic>>> getUserChats(String userId) {
  return _remoteDataSource.getUserChats(userId);
}
Future<Map<String, dynamic>> getUserData(String uid) {
  return _remoteDataSource.getUserData(uid);
}
}
