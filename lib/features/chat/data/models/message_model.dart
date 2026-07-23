import 'package:hive/hive.dart';
import 'package:buddy_ai/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.content,
    required super.sender,
    required super.timestamp,
    super.status = MessageStatus.sent,
  });

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      content: entity.content,
      sender: entity.sender,
      timestamp: entity.timestamp,
      status: entity.status,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      sender: (json['sender'] as String) == 'user'
          ? MessageSender.user
          : MessageSender.ai,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      status: MessageStatus.sent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender == MessageSender.user ? 'user' : 'ai',
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory MessageModel.fromFunctionResponse(Map<String, dynamic> json) {
    return MessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: json['reply'] as String,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
  }
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 0;

  @override
  MessageModel read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return MessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      sender: (map['sender'] as String) == 'user'
          ? MessageSender.user
          : MessageSender.ai,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer.writeMap(obj.toJson());
  }
}