import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/team_model.dart';
import '../../../core/utils/color_cycler.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/teams_provider.dart';
import 'chat_bubble.dart';
import '../../../core/constants/text_styles.dart';
import '../../../widgets/text_input_field.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.subHeading, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              decoration: BoxDecoration(
                color: bubbleColor,

                /// 👇 Remove bottom radius when expanded
                borderRadius: expanded
                    ? BorderRadius.only(
                        topLeft: Radius.circular(AppSpacing.radius),
                        topRight: Radius.circular(AppSpacing.radius),
                      )
                    : BorderRadius.circular(AppSpacing.radius),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.team.name,
                        style: AppTextStyles.bold.copyWith(
                          color: AppColors.body,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.labelGap),
                      Text(
                        widget.team.category,
                        style: AppTextStyles.assist.copyWith(
                          color: AppColors.subHeading,
                        ),
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

                      return Text(
                        '+$count',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.body,
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

          /// ➖ Divider border when expanded
          if (expanded) Container(height: 1, color: AppColors.subHeading),

          /// 📦 EXPANDED CONTENT
          if (expanded) ...[
            SizedBox(
              height: 260,
              child: Container(
                color: AppColors.superlight, // 🎨 Your background color
                child: messagesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (messages) {
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
            ),

            Container(
              decoration: BoxDecoration(
                color: AppColors.superlight,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSpacing.radius),
                  bottomRight: Radius.circular(AppSpacing.radius),
                ),
                border: const Border(
                  top: BorderSide(color: AppColors.subHeading, width: 1),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Row(
                children: [
                  Expanded(
                    child: TextInputField(
                      controller: controller,
                      onSubmitted: (_) => _sendMessage(),
                      placeholder: "Type a message...",
                      label: '',
                      textInputAction: TextInputAction.send,
                      showSendIcon: true,
                      suffixIconFunc: _sendMessage,
                      maxLines: 1,
                    ),
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
