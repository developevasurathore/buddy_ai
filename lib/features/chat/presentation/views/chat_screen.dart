import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddy_ai/di/injection.dart';
import 'package:buddy_ai/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:buddy_ai/features/chat/presentation/widgets/message_bubble.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatViewModelProvider);
    final viewModel = ref.read(chatViewModelProvider.notifier);

    ref.listen(chatViewModelProvider, (previous, next) {
      if (next.failure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.failure!.message)),
        );
        viewModel.dismissError();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Buddy AI')),
      body: Column(
        children: [
          Expanded(
            child: state.isLoadingHistory
                ? const Center(child: CircularProgressIndicator())
                : state.messages.isEmpty
                ? const _EmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: state.messages[index]);
              },
            ),
          ),
          ChatInputField(
            isSending: state.isSending,
            onSend: viewModel.sendMessage,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 48, color: Colors.black26),
          const SizedBox(height: 12),
          Text(
            'Ask me anything to get started',
            style: TextStyle(color: Colors.black.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}