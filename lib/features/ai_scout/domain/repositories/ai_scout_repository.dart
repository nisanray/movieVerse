import '../entities/ai_message_entity.dart';

abstract class AiScoutRepository {
  Future<AiMessageEntity> getAiResponse(String prompt, List<AiMessageEntity> history);
  Future<List<AiMessageEntity>> getHistory();
  Future<void> saveMessage(AiMessageEntity message);
  Future<void> clearHistory();
}
