import 'package:flutter/material.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:social_media_app/features/chat/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/chat/data/model/message_model.dart';

class ChatDetailScreen extends StatelessWidget {
  final UserModle user;
  final  currentUserId;

  const ChatDetailScreen({super.key, required this.user,required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController=ScrollController();

    return Scaffold(
      appBar: PreferredSize(
        
  preferredSize: Size.fromHeight(kToolbarHeight),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: AppBar(
     
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.blue),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade300,
            backgroundImage: user.profileImageUrl != null
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: user.profileImageUrl == null
                ? Text(
                    user.name[0],
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(user.name, style: const TextStyle(color: Colors.black)),
        ],
      ),
    ),
  ),
),
      body: Container(
        color:Colors.white,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: chatViewModel.getMessages(getChatId(currentUserId, user.uid)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }
        
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: false,
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSender = message.senderId == user.uid;
                      return Align(
                        alignment:
                            isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: ChatBubble(
                          text: message.message,
                          isSender: isSender,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        final messageText = messageController.text.trim();
                        final chatid =getChatId(currentUserId, user.uid);
                        if (messageText.isNotEmpty) {
                          chatViewModel.sendMessage(
                            chatid,
                            currentUserId,
                            user.uid,
                            messageText,
                          );
                          messageController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getChatId(String userId1,String userId2){
    final sorted=[userId1,userId2]..sort();
    return "${sorted[0]}_${sorted[1]}";
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const ChatBubble({super.key, required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSender ? Colors.grey[200] : Colors.blue[200],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isSender ? 16 : 0),
          bottomRight: Radius.circular(isSender ? 0 : 16),
        ),
      ),
      child: Text(text),
    );
  }
}
