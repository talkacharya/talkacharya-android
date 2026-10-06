import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:simple_pip_mode/simple_pip.dart';
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
  final _simplePip = SimplePip();

  @override
  void initState() {
    super.initState();
    _simplePip.setAutoPipMode();
    _cubit = buildHostCubit(context, widget.streamId);
    unawaited(_cubit.goLive());
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
        child: BlocConsumer<LiveHostCubit, LiveState>(
          listenWhen: (a, b) =>
              a.phase != b.phase && b.phase == LivePhase.ended,
          listener: (context, state) {
            if (state.endReason == LiveEndReason.hostEnded &&
                Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return PipWidget(
              pipBuilder: (context) {
                return Scaffold(
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
                    ],
                  ),
                );
              },
              builder: (context) => PopScope(
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
                        LivePhase.preparing || LivePhase.joining => const ConnectingView(),
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
            ),
          );
        },
      ),
      ),
    );
  }
}

