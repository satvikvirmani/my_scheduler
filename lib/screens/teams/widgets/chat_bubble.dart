import 'package:flutter/material.dart';
import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

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

    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppSpacing.radius),
              topRight: const Radius.circular(AppSpacing.radius),
              bottomLeft: isMe
                  ? const Radius.circular(2)
                  : const Radius.circular(AppSpacing.radius),
              bottomRight: isMe
                  ? const Radius.circular(AppSpacing.radius)
                  : const Radius.circular(2),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // 💬 Message
              Text(
                message,
                style: AppTextStyles.assist.copyWith(
                  color: AppColors.body,
                )
              ),

              // ⏰ Time (optional)
              if (time != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatTime(time!),
                  style: AppTextStyles.messageTime.copyWith(
                    color: AppColors.body,
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
    final hour = t.hour;
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}