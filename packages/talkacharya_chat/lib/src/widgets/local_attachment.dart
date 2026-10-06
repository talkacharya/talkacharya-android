import 'dart:io';

import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../ports/chat_media.dart';

/// Builds [attachment] from a file on the device, downloading it once first if
/// it is not there yet.
///
/// Three outcomes besides the file itself: still downloading, gone from the
/// server before this device ever fetched it (it keeps media a week), or a
/// failed download that is worth another try.
class LocalAttachment extends StatefulWidget {
  const LocalAttachment({
    required this.attachment,
    required this.store,
    required this.builder,
    required this.loading,
    required this.gone,
    required this.failed,
    super.key,
  });

  final ChatAttachment attachment;
  final ChatMediaStore store;
  final Widget Function(BuildContext context, String path) builder;
  final WidgetBuilder loading;
  final WidgetBuilder gone;
  final Widget Function(BuildContext context, VoidCallback retry) failed;

  @override
  State<LocalAttachment> createState() => _LocalAttachmentState();
}

enum _Phase { loading, ready, gone, failed }

class _LocalAttachmentState extends State<LocalAttachment> {
  _Phase _phase = _Phase.loading;
  String? _path;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  @override
  void didUpdateWidget(covariant LocalAttachment old) {
    super.didUpdateWidget(old);
    // The optimistic bubble (a local path, no id) becomes the server's (an id,
    // no path) once it is sent — same picture, new identity.
    if (old.attachment.id != widget.attachment.id ||
        old.attachment.localPath != widget.attachment.localPath) {
      _resolve();
    }
  }

  Future<void> _resolve() async {
    final a = widget.attachment;
    // Still sending: the file the user picked is right here.
    if (a.localPath.isNotEmpty && await File(a.localPath).exists()) {
      return _set(_Phase.ready, a.localPath);
    }
    if (a.id.isEmpty) return _set(_Phase.loading, null);
    final have = await widget.store.localFor(a);
    if (have != null) return _set(_Phase.ready, have);
    if (!a.available) return _set(_Phase.gone, null);
    _set(_Phase.loading, null);
    try {
      _set(_Phase.ready, await widget.store.fetch(a));
    } on MediaGone {
      _set(_Phase.gone, null);
    } catch (_) {
      _set(_Phase.failed, null);
    }
  }

  void _set(_Phase phase, String? path) {
    if (!mounted) return;
    setState(() {
      _phase = phase;
      _path = path;
    });
  }

  @override
  Widget build(BuildContext context) => switch (_phase) {
    _Phase.ready => widget.builder(context, _path!),
    _Phase.loading => widget.loading(context),
    _Phase.gone => widget.gone(context),
    _Phase.failed => widget.failed(context, _resolve),
  };
}
