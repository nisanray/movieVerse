import 'package:flutter/material.dart';
import '../controllers/ai_scout_controller.dart';

class InputAreaWidget extends StatelessWidget {
  final AiScoutController controller;

  const InputAreaWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: controller.textController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Ask Scout about movies...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (_) {
                    // Trigger rebuild when text changes to update send button color
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: controller.textController.text.trim().isNotEmpty
                    ? Colors.red
                    : Colors.white.withOpacity(0.3),
              ),
              onPressed: controller.textController.text.trim().isNotEmpty
                  ? () => controller.sendMessage()
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
