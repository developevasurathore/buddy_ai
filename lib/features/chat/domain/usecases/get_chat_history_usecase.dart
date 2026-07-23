
import 'package:buddy_ai/core/utils/result.dart';
import 'package:buddy_ai/features/chat/domain/entities/message_entity.dart';
import 'package:buddy_ai/features/chat/domain/repositories/chat_repository.dart';

class GetChatHistoryUseCase {
  final ChatRepository repository;
  const GetChatHistoryUseCase(this.repository);

  Future<Result<List<MessageEntity>>> call() {
    return repository.getChatHistory();
  }
}