import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../gifting/data/models/gift.dart';
import '../../../gifting/presentation/view/gift_sheet.dart';
import '../../../gifting/presentation/widgets/gift_art.dart';
import '../../data/live_adapters.dart';
import '../../data/livestream_api.dart';
import '../../data/models/live_stream_summary.dart';
import 'widgets/live_chat_image.dart';

/// Watching a live stream (`/live/{id}`, deep link `talkacharya://livestreams/{id}`).
///
/// The picture comes from our own media server; the chat, viewer count and gift
/// banners ride the Centrifugo channel. Everything is stacked over the video so the
/// stream itself is never boxed in.
class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({required this.streamId, super.key});

  final String streamId;

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  late final LiveViewerCubit _cubit;
  LiveStreamSummary? _stream;

  @override
  void initState() {
    super.initState();
    final api = getIt<LivestreamApi>();
    _cubit = LiveViewerCubit(
      backend: DioLiveViewerBackend(api, widget.streamId),
      engine: LiveKitRoomEngine(),
      signaling: RealtimeLiveSignaling(getIt<RealtimeClient>()),
      userId: context.read<AuthBloc>().state.user?.id ?? '',
    );
    unawaited(_cubit.start());
    unawaited(_loadDetail(api));
  }

  Future<void> _loadDetail(LivestreamApi api) async {
    try {
      final detail = await api.detail(widget.streamId);
      if (mounted) setState(() => _stream = detail);
    } catch (_) {
      // the room works without the header detail; the video is what matters
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<LiveViewerCubit, LiveState>(
          builder: (context, state) {
            return PopScope(
              canPop: !state.phase.isOn,
              onPopInvokedWithResult: (didPop, _) async {
                if (didPop) return;
                await _cubit.leave();
                if (context.mounted) context.pop();
              },
              child: Scaffold(
                backgroundColor: const Color(0xFF120A26),
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    _Stage(state: state, hostName: _hostName),
                    SafeArea(
                      child: switch (state.phase) {
                        LivePhase.ended => _EndedOverlay(
                          state: state,
                          hostName: _hostName,
                          onClose: () => context.pop(),
                        ),
                        LivePhase.failed => _FailedOverlay(
                          error: state.error,
                          onClose: () => context.pop(),
                        ),
                        _ => _WatchingOverlay(
                          state: state,
                          stream: _stream,
                          hostName: _hostName,
                          onLeave: () async {
                            await _cubit.leave();
                            if (context.mounted) context.pop();
                          },
                        ),
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String get _hostName => _stream?.hostName ?? '';
}

/// The video itself, or something to look at while it is not there.
class _Stage extends StatelessWidget {
  const _Stage({required this.state, required this.hostName});
  final LiveState state;
  final String hostName;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (state.showRemoteVideo) {
      return LiveVideoView(track: state.remoteVideo);
    }
    final message = switch (state.phase) {
      LivePhase.joining || LivePhase.idle => l.liveConnecting,
      LivePhase.reconnecting => l.liveReconnecting,
      LivePhase.live => l.liveHostCameraOff,
      _ => '',
    };
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B0F3B), Color(0xFF2A1454)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: AstroPalette.romance),
              ),
              alignment: Alignment.center,
              child: Text(
                hostName.isEmpty
                    ? '★'
                    : hostName.characters.first.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                message,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Everything laid over a running stream: header, chat, input, gifts.
class _WatchingOverlay extends StatelessWidget {
  const _WatchingOverlay({
    required this.state,
    required this.stream,
    required this.hostName,
    required this.onLeave,
  });

  final LiveState state;
  final LiveStreamSummary? stream;
  final String hostName;
  final Future<void> Function() onLeave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(state: state, hostName: hostName, onLeave: onLeave),
        if (state.pinned != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: _PinnedBanner(message: state.pinned!),
          ),
        const Spacer(),
        if (state.gifts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _GiftBanners(gifts: state.gifts),
          ),
        _ChatFeed(messages: state.messages),
        _Composer(state: state, stream: stream, hostName: hostName),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.state,
    required this.hostName,
    required this.onLeave,
  });

  final LiveState state;
  final String hostName;
  final Future<void> Function() onLeave;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Color(0x00000000)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE5484D),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              l.liveBadge.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hostName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(Icons.visibility_rounded, size: 16, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            '${state.viewerCount}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          IconButton(
            tooltip: l.liveLeave,
            onPressed: onLeave,
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _PinnedBanner extends StatelessWidget {
  const _PinnedBanner({required this.message});
  final LiveChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Icon(Icons.push_pin_rounded, size: 14, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// The last few messages, bottom-anchored over the video like every live app.
class _ChatFeed extends StatelessWidget {
  const _ChatFeed({required this.messages});
  final List<LiveChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();
    final recent = messages.length > 30
        ? messages.sublist(messages.length - 30)
        : messages;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.32,
      ),
      child: ShaderMask(
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black, Colors.black],
          stops: [0, 0.25, 1],
        ).createShader(rect),
        blendMode: BlendMode.dstIn,
        child: ListView.builder(
          reverse: true,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          itemCount: recent.length,
          itemBuilder: (context, i) =>
              _ChatLine(message: recent[recent.length - 1 - i]),
        ),
      ),
    );
  }
}

class _ChatLine extends StatelessWidget {
  const _ChatLine({required this.message});
  final LiveChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

/// "Rose", or "5× Rose" — falls back to the slug when the backend sent no name.
String _giftLabel(LiveGiftEvent gift) {
  final name = gift.giftName.isNotEmpty ? gift.giftName : gift.giftSlug;
  return gift.quantity > 1 ? '${gift.quantity}× $name' : name;
}

class _GiftBanners extends StatelessWidget {
  const _GiftBanners({required this.gifts});
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
              padding: const EdgeInsets.fromLTRB(8, 6, 14, 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFB02E).withValues(alpha: 0.9),
                    const Color(0xFFF07B16).withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GiftArt(slug: gift.giftSlug, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.liveGiftSent(
                      gift.senderName,
                      _giftLabel(gift),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Say something, or send a gift.
class _Composer extends StatefulWidget {
  const _Composer({
    required this.state,
    required this.stream,
    required this.hostName,
  });

  final LiveState state;
  final LiveStreamSummary? stream;
  final String hostName;

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  final _controller = TextEditingController();

  /// Picked but not yet sent.
  String? _imagePath;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    final image = _imagePath;
    if (text.isEmpty && image == null) return;
    _controller.clear();
    setState(() => _imagePath = null);
    await context.read<LiveViewerCubit>().sendChat(text, imagePath: image);
  }

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked != null && mounted) setState(() => _imagePath = picked.path);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.livePhotoFailed)));
    }
  }

  void _gift() {
    final stream = widget.stream;
    if (stream == null) return;
    showGiftSheet(
      context,
      target: LivestreamGiftTarget(
        livestreamId: stream.id,
        astrologerName: stream.hostName,
        currency: stream.giftCurrency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = widget.state;
    final giftable = widget.stream?.giftingEnabled ?? false;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        12 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imagePath != null)
            LiveChatImagePreview(
              path: _imagePath!,
              onRemove: () => setState(() => _imagePath = null),
            ),
          Row(
            children: [
              _CircleButton(
                icon: Icons.image_rounded,
                tooltip: l.liveSendPhoto,
                background: Colors.white.withValues(alpha: 0.18),
                onTap: state.phase.isOn ? _pickImage : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: state.phase.isOn,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  style: const TextStyle(color: Colors.white),
                  maxLength: 500,
                  buildCounter:
                      (
                        _, {
                        required currentLength,
                        required isFocused,
                        maxLength,
                      }) => null,
                  decoration: InputDecoration(
                    hintText: state.slowModeSeconds > 0
                        ? l.liveSlowModeHint(state.slowModeSeconds)
                        : l.liveChatHint,
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.12),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (giftable)
                _CircleButton(
                  icon: Icons.card_giftcard_rounded,
                  tooltip: l.giftAction,
                  background: const Color(0xFFFFB02E),
                  onTap: _gift,
                ),
              const SizedBox(width: 8),
              _CircleButton(
                icon: Icons.send_rounded,
                tooltip: l.liveSend,
                background: Colors.white.withValues(alpha: 0.18),
                onTap: state.sending ? null : _send,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.tooltip,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final Color background;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _EndedOverlay extends StatelessWidget {
  const _EndedOverlay({
    required this.state,
    required this.hostName,
    required this.onClose,
  });

  final LiveState state;
  final String hostName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (title, body) = switch (state.endReason) {
      LiveEndReason.removed => (l.liveRemovedTitle, l.liveRemovedBody),
      LiveEndReason.hostEnded => (
        l.liveEndedTitle,
        hostName.isEmpty ? l.liveEndedBody : l.liveEndedByHost(hostName),
      ),
      _ => (l.liveEndedTitle, l.liveEndedBody),
    };
    return _CenteredMessage(
      icon: state.endReason == LiveEndReason.removed
          ? Icons.block_rounded
          : Icons.live_tv_rounded,
      title: title,
      body: body,
      actionLabel: l.liveBackToList,
      onAction: onClose,
    );
  }
}

class _FailedOverlay extends StatelessWidget {
  const _FailedOverlay({required this.error, required this.onClose});
  final String? error;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _CenteredMessage(
      icon: Icons.signal_wifi_bad_rounded,
      title: l.liveCannotJoinTitle,
      body: error == null || error!.isEmpty
          ? l.liveCannotJoinBody
          : localizedError(context, error),
      actionLabel: l.liveBackToList,
      onAction: onClose,
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.white70),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 26),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
