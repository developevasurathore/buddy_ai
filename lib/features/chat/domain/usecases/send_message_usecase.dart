import 'package:buddy_ai/core/utils/result.dart';
import 'package:buddy_ai/features/chat/domain/entities/message_entity.dart';
import 'package:buddy_ai/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;
  const SendMessageUseCase(this.repository);

  Future<Result<MessageEntity>> call({
    required String content,
    required List<MessageEntity> conversationHistory,
  }) {
    return repository.sendMessage(
      content: content,
      conversationHistory: conversationHistory,
    );
  }
}