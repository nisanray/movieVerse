import '../../domain/entities/ai_message_entity.dart';

class AiMessageModel extends AiMessageEntity {
  AiMessageModel({
    required super.text,
    required super.isUser,
    required super.timestamp,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AiMessageModel.fromEntity(AiMessageEntity entity) {
    return AiMessageModel(
      text: entity.text,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
    );
  }
}
