import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddy_ai/features/chat/domain/entities/message_entity.dart';
import 'package:buddy_ai/features/chat/domain/usecases/get_chat_history_usecase.dart';
import 'package:buddy_ai/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:buddy_ai/features/chat/presentation/viewmodels/chat_state.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetChatHistoryUseCase _getChatHistoryUseCase;

  ChatViewModel({
    required SendMessageUseCase sendMessageUseCase,
    required GetChatHistoryUseCase getChatHistoryUseCase,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _getChatHistoryUseCase = getChatHistoryUseCase,
        super(const ChatState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoadingHistory: true, clearFailure: true);
    final result = await _getChatHistoryUseCase();
    result.when(
      success: (messages) {
        state = state.copyWith(messages: messages, isLoadingHistory: false);
      },
      failure: (failure) {
        state = state.copyWith(isLoadingHistory: false);
      },
    );
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.isSending) return;

    final userMessage = MessageEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: content.trim(),
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isSending: true,
      clearFailure: true,
    );

    final result = await _sendMessageUseCase(
      content: content.trim(),
      conversationHistory: state.messages,
    );

    result.when(
      success: (aiMessage) {
        state = state.copyWith(
          messages: [...state.messages, aiMessage],
          isSending: false,
        );
      },
      failure: (failure) {
        state = state.copyWith(isSending: false, failure: failure);
      },
    );
  }

  void dismissError() {
    state = state.copyWith(clearFailure: true);
  }
}