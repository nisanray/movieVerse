import 'package:get/get.dart'
    hide Response; // Avoid conflict with google_generative_ai
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/utils/storage_service.dart';
import '../models/ai_message_model.dart';
import '../../domain/entities/ai_message_entity.dart';
import '../../domain/repositories/ai_scout_repository.dart';
import 'package:flutter/foundation.dart';

class AiScoutRepositoryImpl implements AiScoutRepository {
  final String _modelName = 'gemini-2.5-flash'; // High-performance Flash model
  final _storage = Get.find<StorageService>();

  // Optimization Constants
  static const int _maxLocalHistory = 40; // Max messages stored in Hive
  static const int _maxContextHistory = 6; // Max messages sent as context to AI

  @override
  Future<List<AiMessageEntity>> getHistory() async {
    final box = _storage.aiHistoryBox;
    final List<dynamic> rawMessages = box.values.toList();
    return rawMessages
        .map((m) => AiMessageModel.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<void> saveMessage(AiMessageEntity message) async {
    final box = _storage.aiHistoryBox;
    
    // Pruning Logic: Keep the local database lightweight
    if (box.length >= _maxLocalHistory) {
      debugPrint('Optimization: Pruning oldest chat message from local storage');
      await box.deleteAt(0); // Remove oldest message
    }

    final model = AiMessageModel.fromEntity(message);
    await box.add(model.toJson());
  }

  @override
  Future<void> clearHistory() async {
    await _storage.aiHistoryBox.clear();
  }

  @override
  Future<AiMessageEntity> getAiResponse(
    String prompt,
    List<AiMessageEntity> history,
  ) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    debugPrint('--- AI GEMINI DEBUG START ---');

    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('CRITICAL: Gemini API Key is null or empty in dotenv.env');
      throw Exception('Gemini API Key not found in environment.');
    }

    try {
      final model = GenerativeModel(
        model: _modelName,
        apiKey: apiKey,
        systemInstruction: Content.system(
          'You are "Movie Scout", a professional and enthusiastic cinematic assistant for the Movie Verse app. '
          'Your goal is to help users find movies and TV shows based on their mood or preferences. '
          'Be elegant, helpful, and use concise, premium language. Always suggest real movies. '
          'Format your responses with Markdown for readability (bold titles, bulleted lists for suggestions).',
        ),
      );

      final chatHistory = _buildChatHistory(history);
      final chat = model.startChat(history: chatHistory);
      final response = await chat.sendMessage(Content.text(prompt));

      final text = response.text;
      if (text == null) {
        throw Exception('Gemini returned an empty response.');
      }

      final aiMessage = AiMessageEntity(
        text: text.trim(),
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Save both user and AI message
      // Note: User message is saved in controller before this call,
      // but let's be safe and save the AI response here.
      await saveMessage(aiMessage);

      debugPrint('Gemini Response Received Successfully');
      return aiMessage;
    } catch (e) {
      debugPrint('--- GEMINI ERROR ---');
      debugPrint('Error: $e');
      rethrow;
    } finally {
      debugPrint('--- AI GEMINI DEBUG END ---');
    }
  }

  List<Content> _buildChatHistory(List<AiMessageEntity> history) {
    // Optimization: Only take the last few messages to reduce token usage and cost
    final recentHistory = history.length > _maxContextHistory
        ? history.sublist(history.length - _maxContextHistory)
        : history;

    return recentHistory.map((msg) {
      if (msg.isUser) {
        return Content.text(msg.text);
      } else {
        return Content.model([TextPart(msg.text)]);
      }
    }).toList();
  }
}
