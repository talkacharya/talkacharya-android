import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import 'go_live_page.dart';
import 'widgets/host_header.dart';
import 'widgets/host_chat.dart';
import 'widgets/host_controls.dart';
import 'widgets/host_system_views.dart';
import 'widgets/on_air_view.dart';
import 'widgets/confirm_end_dialog.dart';

import '../../../../core/l10n/l10n.dart';

/// The broadcast screen: our own camera full-bleed, the chat and viewer count
/// over it, and the controls that matter while on air.
///
/// Going live happens here rather than on the previous screen so the astrologer
/// sees themselves the moment the camera opens.
class HostRoomPage extends StatefulWidget {
  const HostRoomPage({required this.streamId, required this.title, super.key});

  final String streamId;
  final String title;

  @override
  State<HostRoomPage> createState() => _HostRoomPageState();
}

class _HostRoomPageState extends State<HostRoomPage> {
  late final LiveHostCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = buildHostCubit(context, widget.streamId);
    unawaited(_cubit.goLive());
  }

  @override
  void dispose() {
    // Leaving the room: the app no longer follows the user out as a window.
    unawaited(CallPip.setActive(active: false));
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocProvider.value(
        value: _cubit,
        child: BlocConsumer<LiveHostCubit, LiveState>(
          listenWhen: (a, b) => a.phase != b.phase,
          listener: (context, state) {
            // Picture-in-picture only while on air (the camera is live): going
            // home mid-stream keeps the host's video in a corner.
            unawaited(CallPip.setActive(active: state.phase.isOn));
            if (state.phase == LivePhase.ended &&
                state.endReason == LiveEndReason.hostEnded &&
                Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return ValueListenableBuilder<bool>(
              valueListenable: CallPip.inPip,
              builder: (context, inPip, _) {
                if (inPip) {
                  // A thumbnail: just the camera.
                  return Scaffold(
                    backgroundColor: const Color(0xFF12102A),
                    body: state.showLocalVideo
                        ? LiveVideoView(
                            track: state.localVideo,
                            mirror: state.frontCamera,
                          )
                        : const ColoredBox(color: Color(0xFF12102A)),
                  );
                }
                return PopScope(
                  canPop: !state.phase.isOn,
                  onPopInvokedWithResult: (didPop, _) async {
                    if (didPop || !state.phase.isOn) return;
                    if (await confirmHostEnd(context)) {
                      await _cubit.endStream();
                    }
                  },
                  child: Scaffold(
                    backgroundColor: const Color(0xFF12102A),
                    body: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (state.showLocalVideo)
                          LiveVideoView(
                            track: state.localVideo,
                            mirror: state.frontCamera,
                          )
                        else
                          const ColoredBox(color: Color(0xFF12102A)),
                        SafeArea(
                          child: switch (state.phase) {
                            LivePhase.permissionDenied => PermissionView(
                              blocked: state.permanentlyDenied,
                              onSettings: _cubit.openSettings,
                              onRetry: _cubit.retry,
                              onClose: () => Navigator.of(context).pop(),
                            ),
                            LivePhase.failed => FailedView(
                              message: state.error,
                              onRetry: _cubit.retry,
                              onClose: () => Navigator.of(context).pop(),
                            ),
                            LivePhase.ended => EndedView(
                              state: state,
                              onClose: () => Navigator.of(context).pop(),
                            ),
                            LivePhase.preparing ||
                            LivePhase.joining => const ConnectingView(),
                            _ => OnAirView(
                              state: state,
                              title: widget.title,
                              onEnd: () async {
                                if (await confirmHostEnd(context)) {
                                  await _cubit.endStream();
                                }
                              },
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
