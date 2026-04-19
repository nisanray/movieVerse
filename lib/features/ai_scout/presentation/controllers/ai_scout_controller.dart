import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/ai_message_entity.dart';
import '../../domain/repositories/ai_scout_repository.dart';
import '../../../../core/utils/snackbar_utils.dart';

class AiScoutController extends GetxController {
  final AiScoutRepository _repository = Get.find<AiScoutRepository>();
  
  final RxList<AiMessageEntity> messages = <AiMessageEntity>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    isLoading.value = true;
    try {
      final history = await _repository.getHistory();
      if (history.isNotEmpty) {
        messages.addAll(history);
      } else {
        // Add initial greeting if first time
        messages.add(AiMessageEntity(
          text: "Hello! I am your AI Movie Scout. Tell me what kind of movies or shows you're in the mood for, and I'll find the perfect match for you!",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
      _scrollToBottom();
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || isLoading.value) return;

    textController.clear();
    
    // Add user message
    final userMessage = AiMessageEntity(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    _scrollToBottom();

    isLoading.value = true;

    debugPrint('Controller: Attempting to send message: $text');
    try {
      // Save user message to persistent storage
      await _repository.saveMessage(userMessage);

      final response = await _repository.getAiResponse(text, messages);
      debugPrint('Controller: Response received from repository');
      messages.add(response);
      _scrollToBottom();
    } catch (e) {
      debugPrint('Controller: Error caught in sendMessage: $e');
      SnackbarUtils.error(
        title: 'Error',
        message: 'Could not reach Movie Scout. Please check your connection.',
      );
      // Remove the last user message or add an error message? 
      // Let's add an error message for clarity
      messages.add(AiMessageEntity(
        text: "I'm having trouble connecting to my cinematic database. Please try again in a moment.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
      debugPrint('Controller: Message processing finished');
    }
  }

  Future<void> clearChat() async {
    await _repository.clearHistory();
    messages.clear();
    messages.add(AiMessageEntity(
      text: "Chat history cleared. How can I help you discover something new today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
