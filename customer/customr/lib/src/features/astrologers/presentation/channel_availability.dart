import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../shared/widgets/app_snack.dart';
import '../data/models/astrologer.dart';
import 'next_online_label.dart';

/// The three ways to consult, in the order the app offers them.
const kConsultChannels = ['chat', 'voice', 'video'];

AstroHue channelHue(String channel) => switch (channel) {
  'chat' => AstroPalette.career,
  'voice' => AstroPalette.health,
  'video' => AstroPalette.love,
  _ => AstroPalette.money,
};

IconData channelIcon(String channel) => switch (channel) {
  'chat' => Icons.chat_bubble_rounded,
  'voice' => Icons.phone_in_talk_rounded,
  'video' => Icons.videocam_rounded,
  _ => Icons.bolt_rounded,
};

/// "Chat" · "Voice call" · "Video call".
String channelLabel(AppLocalizations l, String channel) => switch (channel) {
  'chat' => l.channelChat,
  'voice' => l.channelVoice,
  'video' => l.channelVideo,
  _ => channel,
};

/// The one-word form for a button: "Chat" · "Call" · "Video".
String channelVerb(AppLocalizations l, String channel) => switch (channel) {
  'voice' => l.channelCall,
  'video' => l.channelVideoShort,
  _ => l.channelChat,
};

/// Why [channel] cannot be booked with [a] right now, in a line a customer
/// can act on — when it is back, or that it is simply not on offer. Null when
/// it can be booked (or has no price, which is not this line's to explain).
String? channelClosedLine(BuildContext context, Astrologer a, String channel) {
  final l = context.l10n;
  return switch (a.stateOf(channel)) {
    ChannelState.backLater => l.astroChannelBack(
      channelLabel(l, channel),
      nextOnlineWhen(context, a.nextOnlineFor(channel)!),
    ),
    ChannelState.off => l.astroChannelOffNow(channelLabel(l, channel)),
    _ => null,
  };
}

/// Tells the customer why [channel] is closed and what is open instead.
/// Returns true when it had something to say.
bool explainClosedChannel(BuildContext context, Astrologer a, String channel) {
  final line = channelClosedLine(context, a, channel);
  if (line == null) return false;
  final l = context.l10n;
  final open = [
    for (final c in a.openChannels)
      if (c != channel) channelLabel(l, c),
  ];
  AppSnack.showTop(
    context,
    open.isEmpty ? line : '$line. ${l.astroAvailableOn(open.join(', '))}',
    type: SnackType.info,
  );
  return true;
}

/// Chat, voice and video as three small tiles: lit in its colour when the
/// astrologer is taking it, quiet when they are not. Only the ones they have
/// a price for are drawn, so the row says "what you can book here, and what
/// of that is open now" at a glance.
class ChannelGlyphs extends StatelessWidget {
  const ChannelGlyphs({required this.astrologer, this.size = 22, super.key});

  final Astrologer astrologer;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final l = context.l10n;
    final a = astrologer;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in kConsultChannels)
          if (a.rateFor(c) != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Tooltip(
                message: channelClosedLine(context, a, c) ?? channelLabel(l, c),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: a.takes(c)
                        ? channelHue(c).tint(0.14)
                        : brand.hairline.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(size * 0.32),
                  ),
                  child: Icon(
                    a.stateOf(c) == ChannelState.backLater
                        ? Icons.schedule_rounded
                        : channelIcon(c),
                    size: size * 0.56,
                    color: a.takes(c)
                        ? channelHue(c).end
                        : brand.inkMuted.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
