import 'package:flutter/material.dart';
import 'package:social_media_app/features/chat/view_model/search_view_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      viewModel.setCurrentUserId(currentUserId);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Search Users')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  viewModel.search(value);
                }
              },
            ),
            const SizedBox(height: 16),
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.results.length,
                    itemBuilder: (context, index) {
                      final user = viewModel.results[index];

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              user.profileImageUrl != null
                                  ? NetworkImage(user.profileImageUrl!)
                                  : null,
                          child:
                              user.profileImageUrl == null
                                  ? Text(
                                    user.name[0],
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  )
                                  : null,
                        ),
                        title: Text(user.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChatDetailScreen(
                                    user: user,
                                    currentUserId: currentUserId,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
