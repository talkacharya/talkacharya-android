import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import 'host_header.dart';
import 'host_chat.dart';
import 'host_controls.dart';
import 'host_system_views.dart';

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
