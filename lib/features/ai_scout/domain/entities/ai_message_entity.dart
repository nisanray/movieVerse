class AiMessageEntity {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AiMessageEntity({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
