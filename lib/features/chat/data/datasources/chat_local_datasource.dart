import 'package:hive_flutter/hive_flutter.dart';
import 'package:buddy_ai/core/constants/api_constants.dart';
import 'package:buddy_ai/core/error/exceptions.dart';
import 'package:buddy_ai/features/chat/data/models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getCachedMessages();
  Future<void> cacheMessage(MessageModel message);
  Future<void> cacheAllMessages(List<MessageModel> messages);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  Box<MessageModel> get _box => Hive.box<MessageModel>(ApiConstants.chatCacheBox);

  @override
  Future<List<MessageModel>> getCachedMessages() async {
    try {
      final messages = _box.values.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheMessage(MessageModel message) async {
    try {
      await _box.put(message.id, message);
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheAllMessages(List<MessageModel> messages) async {
    try {
      final map = {for (final m in messages) m.id: m};
      await _box.putAll(map);
    } catch (_) {
      throw const CacheException();
    }
  }
}