import 'package:google_generative_ai/google_generative_ai.dart' hide ServerException;
import 'package:buddy_ai/core/error/exceptions.dart';
import 'package:buddy_ai/features/chat/data/models/message_model.dart';
import 'package:buddy_ai/features/chat/domain/entities/message_entity.dart';

abstract class ChatRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String content,
    required List<MessageEntity> conversationHistory,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  @override
  Future<MessageModel> sendMessage({
    required String content,
    required List<MessageEntity> conversationHistory,
  }) async {
    try {
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);

      final history = conversationHistory.map((m) {
        return Content(
          m.sender == MessageSender.user ? 'user' : 'model',
          [TextPart(m.content)],
        );
      }).toList();

      final chat = model.startChat(history: history);
      final response = await chat.sendMessage(Content.text(content));

      return MessageModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        content: response.text ?? 'No response',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}