import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/live_adapters.dart';
import '../../data/live_api.dart';
import '../../data/models/host_stream.dart';
import 'host_room_page.dart';
import '../../../../core/network/friendly_error.dart';

/// "Go live" — the astrologer names the session, then goes on air.
///
/// Scheduling and starting are two server calls, so the title is collected first
/// and the stream row is created only when they commit. A stream that is already
/// live (the app was killed mid-session) is offered as "resume" instead.
class GoLivePage extends StatefulWidget {
  const GoLivePage({super.key});

  @override
  State<GoLivePage> createState() => _GoLivePageState();
}

class _GoLivePageState extends State<GoLivePage> {
  final _title = TextEditingController();
  final _api = getIt<LiveApi>();

  List<HostStream> _past = const [];
  HostStream? _resumable;
  bool _loading = true;
  bool _starting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final mine = await _api.mine();
      if (!mounted) return;
      setState(() {
        _resumable = mine.where((s) => s.isLive || s.isScheduled).firstOrNull;
        _past = mine.where((s) => !s.isLive && !s.isScheduled).take(5).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyError(e);
        _loading = false;
      });
    }
  }

  Future<void> _start({HostStream? existing}) async {
    final title = _title.text.trim();
    if (existing == null && title.isEmpty) {
      setState(() => _error = 'Give the session a title first.');
      return;
    }
    setState(() {
      _starting = true;
      _error = null;
    });
    try {
      final stream = existing ?? await _api.schedule(title: title);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              HostRoomPage(streamId: stream.id, title: stream.title),
        ),
      );
      if (!mounted) return;
      setState(() => _starting = false);
      unawaited(_load());
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _error = friendlyError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Go live')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                if (_resumable != null) ...[
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.podcasts_rounded),
                      title: Text(_resumable!.title),
                      subtitle: Text(
                        _resumable!.isLive
                            ? 'Still live — rejoin to keep broadcasting'
                            : 'Scheduled — start when you are ready',
                      ),
                      trailing: FilledButton(
                        onPressed: _starting
                            ? null
                            : () => _start(existing: _resumable),
                        child: Text(_resumable!.isLive ? 'Rejoin' : 'Start'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  'Start a new session',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _title,
                  maxLength: 140,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'What is this session about?',
                    hintText: 'e.g. Evening Q&A — career questions',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Viewers see this title in the app. Your camera and microphone '
                  'turn on as soon as you go live.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _starting ? null : () => _start(),
                  icon: _starting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.videocam_rounded),
                  label: Text(_starting ? 'Starting…' : 'Go live'),
                ),
                if (_past.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Text(
                    'Past sessions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  for (final s in _past)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.title),
                      subtitle: Text(
                        '${s.peakViewers} peak · ${s.totalJoins} joined'
                        '${s.totalGiftValue > 0 ? ' · ${s.giftCurrency} ${s.totalGiftValue.toStringAsFixed(0)} in gifts' : ''}',
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}

/// Builds the host cubit for [HostRoomPage] — kept here so the room itself stays
/// a plain widget over the shared package.
LiveHostCubit buildHostCubit(BuildContext context, String streamId) {
  return LiveHostCubit(
    backend: DioLiveHostBackend(getIt<LiveApi>(), streamId),
    permissions: const PermissionHandlerLivePermissions(),
    engine: LiveKitRoomEngine(),
    signaling: RealtimeLiveSignaling(getIt<RealtimeClient>()),
    userId: context.read<AuthBloc>().state.user?.id ?? '',
  );
}
