import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../data/consultation_api.dart';
import '../../data/models/chat_message.dart';
import '../cubit/chat_cubit.dart';

class ConsultationRoomPage extends StatelessWidget {
  const ConsultationRoomPage({required this.consultationId, super.key});
  final String consultationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        api: getIt<ConsultationApi>(),
        realtime: getIt<RealtimeClient>(),
        consultationId: consultationId,
      )..init(),
      child: const _RoomView(),
    );
  }
}

class _RoomView extends StatefulWidget {
  const _RoomView();
  @override
  State<_RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<_RoomView> {
  final _composer = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _composer.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _viewKundali(BuildContext context) async {
    final id = context.read<ChatCubit>().consultationId;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FutureBuilder<Map<String, dynamic>>(
        future: getIt<ConsultationApi>().chart(id),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const SizedBox(
                height: 200, child: Center(child: CircularProgressIndicator()));
          }
          final payload = snap.data?['payload'] ?? snap.data ?? const {};
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(payload.toString()),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (a, b) => a.messages.length != b.messages.length,
      listener: (_, _) {
        if (_scroll.hasClients) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scroll.animateTo(_scroll.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut);
          });
        }
      },
      builder: (context, state) {
        final c = state.consultation;
        return Scaffold(
          appBar: AppBar(
            title: Text(c?.customerName ?? 'Consultation'),
            bottom: state.otherTyping
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(20),
                    child: Text('typing…', style: TextStyle(fontSize: 12)),
                  )
                : null,
            actions: [
              IconButton(
                icon: const Icon(Icons.auto_awesome_rounded),
                tooltip: 'View kundali',
                onPressed: () => _viewKundali(context),
              ),
              if (c != null && c.isLive)
                TextButton(
                  onPressed: () => context.read<ChatCubit>().endConsultation(),
                  child: const Text('End'),
                ),
            ],
          ),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : c != null && c.isEnded
                  ? _Summary(c)
                  : Column(
                      children: [
                        if (c != null && c.isLive)
                          _BillingHud(minutes: c.billedMinutes, earned: c.astrologerAmount, currency: c.currency),
                        Expanded(
                          child: ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.all(12),
                            itemCount: state.messages.length,
                            itemBuilder: (context, i) =>
                                _Bubble(state.messages[i]),
                          ),
                        ),
                        _Composer(
                          controller: _composer,
                          onChanged:
                              context.read<ChatCubit>().onComposerChanged,
                          onSend: () {
                            context
                                .read<ChatCubit>()
                                .sendText(_composer.text);
                            _composer.clear();
                          },
                        ),
                      ],
                    ),
        );
      },
    );
  }
}

class _BillingHud extends StatelessWidget {
  const _BillingHud({required this.minutes, required this.earned, required this.currency});
  final int minutes;
  final String earned;
  final String currency;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Text('$minutes min · earned $currency $earned',
            textAlign: TextAlign.center),
      );
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.m);
  final ChatMessage m;
  @override
  Widget build(BuildContext context) {
    if (m.isSystem) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(m.body, style: Theme.of(context).textTheme.labelSmall),
        ),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: m.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: m.isMine ? scheme.primary : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          m.body,
          style: TextStyle(color: m.isMine ? scheme.onPrimary : null),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onChanged,
    required this.onSend,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Message'),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.send_rounded), onPressed: onSend),
        ]),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary(this.c);
  final dynamic c;
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(24), children: [
      const Icon(Icons.check_circle_outline_rounded, size: 56),
      const SizedBox(height: 12),
      Center(
        child: Text('Consultation ended',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      const SizedBox(height: 24),
      _row('Billed', '${c.billedMinutes} min'),
      _row('Rate', '${c.currency} ${c.rateSnapshot}/min'),
      _row('You earned', '${c.currency} ${c.astrologerAmount}'),
    ]);
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Expanded(child: Text(k, style: const TextStyle(color: Colors.grey))),
          Text(v),
        ]),
      );
}
