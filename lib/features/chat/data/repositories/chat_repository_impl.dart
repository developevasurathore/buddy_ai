import 'package:buddy_ai/core/error/exceptions.dart';
import 'package:buddy_ai/core/error/failures.dart';
import 'package:buddy_ai/core/network/network_info.dart';
import 'package:buddy_ai/core/utils/result.dart';
import 'package:buddy_ai/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:buddy_ai/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:buddy_ai/features/chat/data/models/message_model.dart';
import 'package:buddy_ai/features/chat/domain/entities/message_entity.dart';
import 'package:buddy_ai/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<MessageEntity>> sendMessage({
    required String content,
    required List<MessageEntity> conversationHistory,
  }) async {
    if (!await networkInfo.isConnected) {
      return  Result.failure(NetworkFailure());
    }
    try {
      final aiReply = await remoteDataSource.sendMessage(
        content: content,
        conversationHistory: conversationHistory,
      );
      await localDataSource.cacheMessage(aiReply);
      return Result.success(aiReply);
    } on RateLimitException catch (e) {
      return Result.failure(RateLimitFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    } catch (_) {
      return  Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<List<MessageEntity>>> getChatHistory() async {
    try {
      final cached = await localDataSource.getCachedMessages();
      return Result.success(cached);
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    } catch (_) {
      return  Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> cacheMessage(MessageEntity message) async {
    try {
      await localDataSource.cacheMessage(MessageModel.fromEntity(message));
      return  Result.success(null);
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    } catch (_) {
      return  Result.failure(UnknownFailure());
    }
  }
}