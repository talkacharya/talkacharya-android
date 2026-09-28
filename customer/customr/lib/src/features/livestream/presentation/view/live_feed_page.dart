import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/live_adapters.dart';
import '../../data/livestream_api.dart';
import '../../data/models/live_stream_summary.dart';
import 'live_room_page.dart';

/// Swipe from one live astrologer to the next.
///
/// A list of live streams asks someone to choose before they have seen
/// anything. A feed shows them one, and the cost of trying the next is a
/// flick — which is the whole reason this format took over.
///
/// **Only one stream is ever connected.** The discipline is the feature: two
/// live WebRTC subscriptions is double the bandwidth and battery for a picture
/// nobody is looking at, and on the connections most of these viewers have it
/// would degrade the one they *are* watching. Neighbours are prefetched only
/// as far as their details — never as a second live connection.
class LiveFeedPage extends StatefulWidget {
  const LiveFeedPage({this.startAt, super.key});

  /// Open on this stream if it is in the feed — following a deep link or a
  /// tap from the list without losing the swipe.
  final String? startAt;

  @override
  State<LiveFeedPage> createState() => _LiveFeedPageState();
}

class _LiveFeedPageState extends State<LiveFeedPage> {
  final _api = getIt<LivestreamApi>();
  late final PageController _pages;

  List<LiveStreamSummary> _streams = const [];
  bool _loading = true;
  String? _error;
  int _index = 0;

  /// The cubit for the page on screen. There is never a second one.
  LiveViewerCubit? _current;
  String? _currentId;

  @override
  void initState() {
    super.initState();
    _pages = PageController();
    unawaited(_load());
  }

  @override
  void dispose() {
    _pages.dispose();
    unawaited(_current?.close());
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final all = await _api.list(status: 'live', order: 'feed');
      if (!mounted) return;
      var index = 0;
      if (widget.startAt != null) {
        final at = all.indexWhere((s) => s.id == widget.startAt);
        if (at >= 0) index = at;
      }
      setState(() {
        _streams = all;
        _index = index;
        _loading = false;
      });
      if (index > 0 && _pages.hasClients) _pages.jumpToPage(index);
      _attach(index);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '$e';
        });
      }
    }
  }

  /// Connect page [i] and tear down whatever was connected before it.
  void _attach(int i) {
    if (i < 0 || i >= _streams.length) return;
    final stream = _streams[i];
    if (_currentId == stream.id) return;

    final old = _current;
    _current = null;
    // Closed after the new one is built so the screen never flashes empty,
    // and awaited nowhere: a teardown that hangs must not hold up the swipe.
    unawaited(old?.close());

    final next = LiveViewerCubit(
      backend: DioLiveViewerBackend(_api, stream.id),
      engine: LiveKitRoomEngine(),
      signaling: RealtimeLiveSignaling(getIt<RealtimeClient>()),
      userId: context.read<AuthBloc>().state.user?.id ?? '',
    );
    setState(() {
      _current = next;
      _currentId = stream.id;
    });
    unawaited(next.start());
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Builder(
          builder: (context) {
            if (_loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_streams.isEmpty) {
              return _Empty(
                message: _error == null ? l.liveFeedEmpty : l.liveFeedError,
                onRetry: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  unawaited(_load());
                },
              );
            }
            return PageView.builder(
              controller: _pages,
              scrollDirection: Axis.vertical,
              itemCount: _streams.length,
              onPageChanged: (i) {
                setState(() => _index = i);
                _attach(i);
              },
              itemBuilder: (context, i) {
                final stream = _streams[i];
                // Only the page on screen gets the live view; the others are
                // a poster, which is all a page you are swiping past needs.
                if (i != _index || _current == null) {
                  return _Poster(stream: stream);
                }
                return BlocProvider.value(
                  value: _current!,
                  child: LiveRoomBody(
                    key: ValueKey(stream.id),
                    streamId: stream.id,
                    stream: stream,
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

/// A page the reader is swiping past: the host, and nothing that costs
/// bandwidth.
class _Poster extends StatelessWidget {
  const _Poster({required this.stream});
  final LiveStreamSummary stream;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              child: Text(
                stream.hostName.isEmpty
                    ? '?'
                    : stream.hostName.characters.first.toUpperCase(),
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              stream.hostName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stream.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.live_tv_rounded, size: 40, color: Colors.white38),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    );
  }
}
