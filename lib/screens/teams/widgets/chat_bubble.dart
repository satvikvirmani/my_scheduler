import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Color color;
  final DateTime? time; // 👈 optional timestamp

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.color,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isMe ? color : Colors.grey.shade200;
    final textColor = isMe ? Colors.white : Colors.black87;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, // ✅ fixed
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: isMe
                  ? const Radius.circular(14)
                  : const Radius.circular(2),
              bottomRight: isMe
                  ? const Radius.circular(2)
                  : const Radius.circular(14),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // 💬 Message
              Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),

              // ⏰ Time (optional)
              if (time != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatTime(time!),
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}