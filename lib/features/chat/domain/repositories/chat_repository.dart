import 'package:buddy_ai/core/utils/result.dart';
import 'package:buddy_ai/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<Result<MessageEntity>> sendMessage({
    required String content,
    required List<MessageEntity> conversationHistory,
  });

  Future<Result<List<MessageEntity>>> getChatHistory();

  Future<Result<void>> cacheMessage(MessageEntity message);
}