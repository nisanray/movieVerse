import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../domain/entities/ai_message_entity.dart';

class MessageBubbleWidget extends StatelessWidget {
  final AiMessageEntity message;

  const MessageBubbleWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          color: isUser 
            ? Colors.red.withOpacity(0.9) 
            : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          border: Border.all(
            color: isUser 
              ? Colors.red.withOpacity(0.5) 
              : Colors.white.withOpacity(0.1),
          ),
        ),
        child: isUser 
          ? Text(
              message.text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            )
          : MarkdownBody(
              data: message.text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
                strong: GoogleFonts.poppins(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
                code: GoogleFonts.poppins(
                  color: Colors.blueAccent,
                  fontSize: 13,
                ),
                codeblockDecoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
      ),
    );
  }
}
