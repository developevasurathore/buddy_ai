import 'package:equatable/equatable.dart';

enum MessageSender { user, ai }

enum MessageStatus { sending, sent, streaming, failed }

class MessageEntity extends Equatable {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final MessageStatus status;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  MessageEntity copyWith({
    String? content,
    MessageStatus? status,
  }) {
    return MessageEntity(
      id: id,
      content: content ?? this.content,
      sender: sender,
      timestamp: timestamp,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, content, sender, timestamp, status];
}