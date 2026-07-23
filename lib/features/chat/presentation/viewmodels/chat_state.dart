import 'package:equatable/equatable.dart';
import 'package:buddy_ai/core/error/failures.dart';
import 'package:buddy_ai/features/chat/domain/entities/message_entity.dart';

class ChatState extends Equatable {
  final List<MessageEntity> messages;
  final bool isSending;
  final bool isLoadingHistory;
  final Failure? failure;

  const ChatState({
    this.messages = const [],
    this.isSending = false,
    this.isLoadingHistory = false,
    this.failure,
  });

  ChatState copyWith({
    List<MessageEntity>? messages,
    bool? isSending,
    bool? isLoadingHistory,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [messages, isSending, isLoadingHistory, failure];
}