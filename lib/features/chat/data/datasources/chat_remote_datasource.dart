import 'package:cloud_functions/cloud_functions.dart';
import 'package:buddy_ai/core/constants/api_constants.dart';
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
  final FirebaseFunctions functions;
  const ChatRemoteDataSourceImpl(this.functions);

  @override
  Future<MessageModel> sendMessage({
    required String content,
    required List<MessageEntity> conversationHistory,
  }) async {
    try {
      final callable = functions.httpsCallable(
        ApiConstants.sendMessageFunction,
        options: HttpsCallableOptions(timeout: ApiConstants.requestTimeout),
      );

      final response = await callable.call<Map<String, dynamic>>({
        'message': content,
        'history': conversationHistory
            .map((m) => {
          'role': m.sender == MessageSender.user ? 'user' : 'assistant',
          'content': m.content,
        })
            .toList(),
      });

      return MessageModel.fromFunctionResponse(response.data);
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'resource-exhausted') {
        throw RateLimitException(e.message ?? 'Rate limit exceeded');
      }
      throw ServerException(e.message ?? 'Cloud Function call failed');
    } catch (_) {
      throw const ServerException();
    }
  }
}