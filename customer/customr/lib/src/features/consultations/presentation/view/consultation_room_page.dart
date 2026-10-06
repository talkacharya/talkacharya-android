import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../data/consultation_repository.dart';
import '../../data/models/conversation.dart';
import 'widgets/room_scope.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';
import 'widgets/chat_room_skeleton.dart';

/// One route (`/consultations/:id`) for a thread and whatever session is in it:
/// a call gets the full-screen call surface while it runs; everything else is
/// the conversation, with the session's state inside it. The chat surface is
/// the shared `talkacharya_chat` engine.
///
/// Resolves whatever id the route carried — a thread's, or one of its
/// consultations' — into the thread, before anything else is built.
///
/// It has to happen first: the realtime channels are keyed on the conversation,
/// so a room built with a consultation id would subscribe to a channel nothing
/// publishes to and sit there silent.
class ConsultationRoomPage extends StatefulWidget {
  const ConsultationRoomPage({required this.consultationId, super.key});

  final String consultationId;

  @override
  State<ConsultationRoomPage> createState() => _ConsultationRoomPageState();
}

class _ConsultationRoomPageState extends State<ConsultationRoomPage> {
  // Not `final`: retry has to be able to replace a failed future.
  late Future<Conversation> _thread;

  @override
  void initState() {
    super.initState();
    _thread = _load();
  }

  Future<Conversation> _load() =>
      getIt<ConsultationRepository>().conversation(widget.consultationId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Conversation>(
      future: _thread,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: ChatRoomSkeleton()));
        }
        final thread = snap.data;
        if (thread == null) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorView(
              message: snap.error == null
                  ? context.l10n.roomOpenError
                  : friendlyError(snap.error!),
              // A fresh request, not just a rebuild against the same failed
              // future.
              onRetry: () => setState(() => _thread = _load()),
            ),
          );
        }
        return RoomScope(threadId: thread.id);
      },
    );
  }
}
