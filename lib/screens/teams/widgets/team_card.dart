import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/team_model.dart';
import '../../../core/utils/color_cycler.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/teams_provider.dart';
import 'chat_bubble.dart';

class TeamCard extends ConsumerStatefulWidget {
  final Team team;
  final int index;

  const TeamCard({super.key, required this.team, required this.index});

  @override
  ConsumerState<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends ConsumerState<TeamCard> {
  bool expanded = false;
  final controller = TextEditingController();
  final scrollController = ScrollController();

  String get currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  Future<void> _toggleExpanded() async {
    final repo = ref.read(teamsRepositoryProvider);

    setState(() => expanded = !expanded);

    if (!expanded) return;

    await repo.markTeamSeen(widget.team.id);
    ref.invalidate(unreadCountProvider(widget.team.id));

    _scrollToBottom();
  }

  void _sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    ref
        .read(teamsRepositoryProvider)
        .sendMessage(teamId: widget.team.id, text: text);

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = ColorCycler.byIndex(widget.index);

    final messagesAsync = ref.watch(teamMessagesProvider(widget.team.id));

    final unreadAsync = ref.watch(unreadCountProvider(widget.team.id));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          /// ---------------- HEADER ----------------
          InkWell(
            onTap: _toggleExpanded,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.team.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.team.category,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// 🔔 Unread Badge
                  unreadAsync.when(
                    data: (count) {
                      if (count == 0 || expanded) {
                        return const SizedBox();
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ),
          ),

          /// ---------------- CHAT ----------------
          if (expanded) ...[
            const SizedBox(height: 8),

            SizedBox(
              height: 260,
              child: messagesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (messages) {
                  // ✅ Ensure correct order (oldest → newest)
                  final sortedMessages = [...messages]
                    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

                  _scrollToBottom();

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: sortedMessages.length,
                    itemBuilder: (context, index) {
                      final msg = sortedMessages[index];

                      return ChatBubble(
                        message: msg.message,
                        isMe: msg.senderId == currentUserId,
                        color: bubbleColor,
                        time: msg.createdAt,
                      );
                    },
                  );
                },
              ),
            ),

            const Divider(height: 1),

            /// ✍️ Input
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
