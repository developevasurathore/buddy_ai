import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:buddy_ai/core/constants/api_constants.dart';
import 'package:buddy_ai/features/chat/data/models/message_model.dart';
import 'package:buddy_ai/features/chat/presentation/views/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(MessageModelAdapter());
  await Hive.openBox<MessageModel>(ApiConstants.chatCacheBox);

  runApp(const ProviderScope(child: BuddyAiApp()));
}

class BuddyAiApp extends StatelessWidget {
  const BuddyAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buddy AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      ),
      home: const ChatScreen(),
    );
  }
}