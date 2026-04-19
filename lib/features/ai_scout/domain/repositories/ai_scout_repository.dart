import '../entities/ai_message_entity.dart';

abstract class AiScoutRepository {
  Future<AiMessageEntity> getAiResponse(String prompt, List<AiMessageEntity> history);
}
