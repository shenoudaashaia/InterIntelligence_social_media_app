import 'package:flutter/material.dart';
import 'package:social_media_app/core/widget/chat_appbar.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:social_media_app/features/chat/view/chat_detail_screen.dart';
import 'package:social_media_app/features/chat/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      body: Column(
        children: [
          ChatAppbar(uid: currentUserId),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: chatViewModel.getUserChats(currentUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No messages yet");
                      }

                      final chats = snapshot.data!;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children:
                              chats.map((chat) {
                                final chatId = chat['chatId'];
                                final lastMessage = chat['lastMessage'] ?? '';
                                final otherUserId = chatId
                                    .split('_')
                                    .firstWhere((id) => id != currentUserId);
                                return FutureBuilder<Map<String, dynamic>>(
                                  future: chatViewModel.getUserData(
                                    otherUserId,
                                  ),
                                  builder: (context, userSnapshot) {
                                    if (!userSnapshot.hasData) {
                                      return SizedBox.shrink();
                                    }
                                    final userData = userSnapshot.data!;
                                    final userModel = UserModle.fromjson(
                                      userData,
                                    );
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.blue.shade300,
                                        backgroundImage:
                                            userModel.profileImageUrl != null
                                                ? NetworkImage(
                                                  userModel.profileImageUrl!,
                                                )
                                                : null,
                                        child:
                                            userModel.profileImageUrl == null
                                                ? Text(
                                                  userModel.name[0],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                )
                                                : null,
                                      ),
                                      title: Text(userModel.name),
                                      subtitle: Text(lastMessage),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => ChatDetailScreen(
                                                  user: userModel,
                                                  currentUserId: currentUserId,
                                                ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
