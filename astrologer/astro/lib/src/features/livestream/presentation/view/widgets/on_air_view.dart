import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import 'call_photo_strip.dart';
import 'host_call_panel.dart';
import 'host_header.dart';
import 'host_chat.dart';
import 'host_controls.dart';

/// The call on air, if one is.
LiveCallRequest? _onAir(LiveState state) {
  for (final r in state.callLine) {
    if (r.status == LiveCallStatus.active) return r;
  }
  return null;
}

class OnAirView extends StatelessWidget {
  const OnAirView({
    required this.state,
    required this.title,
    required this.onEnd,
    super.key,
  });

  final LiveState state;
  final String title;
  final Future<void> Function() onEnd;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LiveHostCubit>();
    return Column(
      children: [
        HostHeader(state: state, title: title, onEnd: onEnd),
        const Spacer(),
        if (state.gifts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GiftStrip(gifts: state.gifts),
          ),
        HostChat(messages: state.messages),
        // A call on air: photos only the astrologer and the caller see.
        if (_onAir(state) case final call?)
          CallPhotoStrip(
            photos: state.callPhotos,
            sending: state.sendingPhoto,
            peerName: call.customerName,
            onSend: cubit.sendCallPhoto,
          ),
        // Calls during the stream: the one on air, and the line.
        HostCallPanel(state: state, cubit: cubit),
        HostControls(
          state: state,
          onCamera: cubit.toggleCamera,
          onMic: cubit.toggleMic,
          onFlip: cubit.switchCamera,
          onModerate: () => showModerationSheet(context, cubit, state),
        ),
      ],
    );
  }
}
