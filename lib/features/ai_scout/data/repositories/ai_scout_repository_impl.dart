import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/ai_message_entity.dart';
import '../../domain/repositories/ai_scout_repository.dart';

class AiScoutRepositoryImpl implements AiScoutRepository {
  final String _modelName = 'gemini-2.5-flash'; // High-performance Flash model

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
        // Optional: specify apiVersion if needed, but SDK should handle it
        systemInstruction: Content.system(
          'You are "Movie Scout", a professional and enthusiastic cinematic assistant for the Movie Verse app. '
          'Your goal is to help users find movies and TV shows based on their mood or preferences. '
          'Be elegant, helpful, and use concise, premium language. Always suggest real movies. '
          'If the user asks for something unrelated to movies or TV shows, gently lead them back to cinema.'
        ),
      );

      // Convert history to Generative AI content
      final chatHistory = _buildChatHistory(history);
      
      final chat = model.startChat(history: chatHistory);
      final response = await chat.sendMessage(Content.text(prompt));

      final text = response.text;
      if (text == null) {
        throw Exception('Gemini returned an empty response.');
      }

      debugPrint('Gemini Response Received Successfully');
      return AiMessageEntity(
        text: text.trim(),
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('--- GEMINI ERROR ---');
      debugPrint('Error: $e');
      rethrow;
    } finally {
      debugPrint('--- AI GEMINI DEBUG END ---');
    }
  }

  List<Content> _buildChatHistory(List<AiMessageEntity> history) {
    // Only take the last 10 messages to keep context efficient
    final recentHistory = history.length > 10 ? history.sublist(history.length - 10) : history;
    
    return recentHistory.map((msg) {
      if (msg.isUser) {
        return Content.text(msg.text);
      } else {
        return Content.model([TextPart(msg.text)]);
      }
    }).toList();
  }
}
