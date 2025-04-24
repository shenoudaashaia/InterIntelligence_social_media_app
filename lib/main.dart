import 'package:flutter/material.dart';
import 'package:social_media_app/features/auth/repository/auth_reposiotres.dart';
import 'package:social_media_app/features/auth/view/screen/regester_screen.dart';
import 'package:social_media_app/features/auth/view_model/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_app/features/auth/view_model/profile_view_model.dart';
import 'package:social_media_app/features/chat/view_model/chat_view_model.dart';
import 'package:social_media_app/features/chat/view_model/search_view_model.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(AuthRepository())),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel(AuthRepository())),
      ],
      child: SocialMediaApp(),
    ),
  );
}

class SocialMediaApp extends StatelessWidget {
  const SocialMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegesterScreen(),
    );
  }
}
