import 'package:flutter/material.dart';
import 'package:social_media_app/features/chat/view/chat.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Chat(), 
      ),
    );
  }
}
