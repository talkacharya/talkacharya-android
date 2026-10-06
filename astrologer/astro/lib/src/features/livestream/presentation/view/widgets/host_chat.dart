import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../../core/l10n/l10n.dart';
import 'live_chat_image.dart';

class HostChat extends StatelessWidget {
  const HostChat({required this.messages, super.key});
  final List<LiveChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          'Questions from viewers appear here.',
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
      );
    }
    final recent = messages.length > 30
        ? messages.sublist(messages.length - 30)
        : messages;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.3,
      ),
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        itemCount: recent.length,
        itemBuilder: (context, i) {
          final message = recent[recent.length - 1 - i];
          return InkWell(
            onLongPress: () => showMessageActions(context, message),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13, height: 1.3),
                      children: [
                        TextSpan(
                          text: '${message.name}  ',
                          style: TextStyle(
                            color: message.isHost
                                ? const Color(0xFFFFC53D)
                                : Colors.white70,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (message.text.isEmpty && message.hasImage)
                          TextSpan(
                            text: context.l10n.livePhotoLabel,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          TextSpan(
                            text: message.text,
                            style: const TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                  if (message.hasImage) LiveChatImage(url: message.imageUrl!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GiftStrip extends StatelessWidget {
  const GiftStrip({required this.gifts, super.key});
  final List<LiveGiftEvent> gifts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final gift in gifts)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB02E).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '🎁  ${gift.senderName} sent ${gift.quantity > 1 ? '${gift.quantity}× ' : ''}'
                '${gift.giftName.isEmpty ? 'a gift' : gift.giftName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Future<void> showMessageActions(
  BuildContext context,
  LiveChatMessage message,
) async {
  final cubit = context.read<LiveHostCubit>();
  final l = context.l10n;
  await showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(message.name), subtitle: Text(message.text)),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.push_pin_rounded),
            title: Text(l.hostPin),
            onTap: () {
              cubit.pinMessage(message.id);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility_off_rounded),
            title: Text(l.hostHide),
            onTap: () {
              cubit.hideMessage(message.id);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.translate_rounded),
            title: const Text('Translate'),
            onTap: () {
              cubit.translateMessage(message.id);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.block_rounded, color: Color(0xFFE5484D)),
            title: Text(l.hostRemove),
            subtitle: Text(l.hostRemoveBody),
            onTap: () {
              cubit.removeViewer(message.userId);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    ),
  );
}
