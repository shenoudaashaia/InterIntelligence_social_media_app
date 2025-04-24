import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/widget/profile_image.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:social_media_app/features/auth/view/screen/profile_screen.dart';
import 'package:social_media_app/features/chat/view/search_screen.dart';
import 'package:social_media_app/features/chat/view_model/chat_view_model.dart';

class ChatAppbar extends StatefulWidget {
  final String uid;

  const ChatAppbar({super.key, required this.uid});

  @override
  State<ChatAppbar> createState() => _ChatAppbarState();
}

class _ChatAppbarState extends State<ChatAppbar> {
  late Future<Map<String, dynamic>> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getUserData();
  }

  Future<Map<String, dynamic>> getUserData() {
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    return chatViewModel.getUserData(widget.uid);
  }

  void refreshUserData() {
    setState(() {
      userFuture = getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 15,
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingRow();
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Text("Error loading user");
            }

            final userData = snapshot.data!;
            final String? imageUrl = userData['profileImageUrl'];
            final String username = userData['name'] ?? 'User';

            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final user = UserModle(
                      uid: widget.uid,
                      name: username,
                      email: userData['email'] ?? '',
                      profileImageUrl: imageUrl ?? '',
                      about: userData['about'] ?? '',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: user),
                      ),
                    ).then((_) {
                      refreshUserData();
                    });
                  },
                  child: ProfileImage(
                    imageUrl: imageUrl,

                    username: username,
                    size: 50,
                  ),
                ),
                const Spacer(),

                const Text(
                  "Chat",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),

                const Spacer(),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.person_add_alt,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingRow() {
    return Row(
      children: const [
        CircleAvatar(radius: 25, backgroundColor: Colors.grey),
        Spacer(),
        Text(
          "Chat",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Spacer(),
        Icon(Icons.person_add_alt_1),
        SizedBox(width: 10),
        Icon(Icons.search),
      ],
    );
  }
}
