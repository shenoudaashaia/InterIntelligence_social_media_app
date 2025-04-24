import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatId, MessageModel message) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());
    await _firestore.collection('chats').doc(chatId).set({
      'lastMessage': message.message,
    }, SetOptions(merge: true));
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> getUserChats(String currentUserId) {
    return FirebaseFirestore.instance.collection('chats').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .where((doc) {
            final chatId = doc.id;
            return chatId.contains(currentUserId);
          })
          .map((doc) {
            return {'chatId': doc.id, 'lastMessage': doc['lastMessage'] ?? ''};
          })
          .toList();
    });
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }
}
