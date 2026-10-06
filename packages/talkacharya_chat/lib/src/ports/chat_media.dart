import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/chat_message.dart';

/// The server no longer has this attachment (it keeps chat media for a week).
/// Not an error to retry — the thread says "no longer available" instead.
class MediaGone implements Exception {
  const MediaGone();
}

/// Fetch [url] into [savePath]. Throws [MediaGone] on 404/410, anything else
/// on a failure worth retrying. The app supplies it, because only the app
/// knows which URLs need its auth header (its own API) and which must not have
/// one (a signed storage URL rejects a second credential).
typedef MediaDownload = Future<void> Function(String url, String savePath);

/// Chat photos and voice notes, kept on the device.
///
/// The WhatsApp model: each attachment is downloaded once, the first time it is
/// shown, and every later view is read off the disk. The server keeps its copy
/// only for a week (`MESSAGING.ATTACHMENT_RETENTION_DAYS`), because storage and
/// egress are what cost money — after that, the phone's copy is the only one.
/// The sender never downloads their own: the file they picked is kept under the
/// attachment's id the moment the upload comes back.
abstract class ChatMediaStore {
  /// The local file for [a], if it is already on the device.
  Future<String?> localFor(ChatAttachment a);

  /// The local file for [a], downloading it first if need be. Concurrent calls
  /// for the same attachment share one download. Throws [MediaGone].
  Future<String> fetch(ChatAttachment a);

  /// Keep [sourcePath] — a file this device already has, like the photo that
  /// was just sent — as the copy of [a].
  Future<void> keep(ChatAttachment a, String sourcePath);

  /// Delete everything, e.g. on sign-out on a shared phone.
  Future<void> clear();
}

/// [ChatMediaStore] on the app's support directory: `chat_media/<id>.<ext>`.
///
/// Support rather than documents or cache: the OS does not evict it under
/// storage pressure (cache would, and the server copy may already be gone), and
/// it stays out of the gallery and the user's files.
class DeviceChatMediaStore implements ChatMediaStore {
  DeviceChatMediaStore({
    required MediaDownload download,
    Future<Directory> Function()? root,
  }) : _download = download,
       _root = root ?? getApplicationSupportDirectory;

  final MediaDownload _download;
  final Future<Directory> Function() _root;

  /// Paths already found this session, so a scrolling list does not ask the
  /// filesystem for every bubble on every frame.
  final _known = <String, String>{};
  final _inflight = <String, Future<String>>{};
  Directory? _dir;

  Future<Directory> _folder() async {
    final existing = _dir;
    if (existing != null) return existing;
    final dir = Directory('${(await _root()).path}/chat_media');
    if (!await dir.exists()) await dir.create(recursive: true);
    return _dir = dir;
  }

  Future<String> _pathFor(ChatAttachment a) async =>
      '${(await _folder()).path}/${_safe(a.id)}${extensionFor(a)}';

  @override
  Future<String?> localFor(ChatAttachment a) async {
    if (a.id.isEmpty) return null;
    final hit = _known[a.id];
    if (hit != null) return hit;
    final path = await _pathFor(a);
    if (await File(path).exists()) return _known[a.id] = path;
    return null;
  }

  @override
  Future<String> fetch(ChatAttachment a) async {
    final have = await localFor(a);
    if (have != null) return have;
    if (!a.available || a.url.isEmpty) throw const MediaGone();
    // A block body, not `=> _inflight.remove(...)`: that returns the removed
    // future, which `whenComplete` then waits on — the download waiting on
    // itself, forever.
    return _inflight[a.id] ??= _get(a).whenComplete(() {
      _inflight.remove(a.id);
    });
  }

  Future<String> _get(ChatAttachment a) async {
    final path = await _pathFor(a);
    // Into a side file first: a download cut off halfway must never be taken
    // for the real thing on the next open.
    final part = '$path.part';
    try {
      await _download(a.url, part);
      await File(part).rename(path);
    } catch (_) {
      final leftover = File(part);
      if (await leftover.exists()) await leftover.delete();
      rethrow;
    }
    return _known[a.id] = path;
  }

  @override
  Future<void> keep(ChatAttachment a, String sourcePath) async {
    if (a.id.isEmpty || sourcePath.isEmpty) return;
    final source = File(sourcePath);
    if (!await source.exists()) return;
    final path = await _pathFor(a);
    // A copy, not a move: the picker's file may belong to someone else (the
    // gallery), and the outbox may still want it for a retry.
    await source.copy(path);
    _known[a.id] = path;
  }

  @override
  Future<void> clear() async {
    _known.clear();
    final dir = Directory('${(await _root()).path}/chat_media');
    if (await dir.exists()) await dir.delete(recursive: true);
    _dir = null;
  }

  static String _safe(String id) => id.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
}

/// A file extension for [a], so players that sniff by name (audio) get one.
String extensionFor(ChatAttachment a) {
  const byType = {
    'image/jpeg': '.jpg',
    'image/jpg': '.jpg',
    'image/png': '.png',
    'image/webp': '.webp',
    'image/heic': '.heic',
    'image/gif': '.gif',
    'audio/mp4': '.m4a',
    'audio/m4a': '.m4a',
    'audio/x-m4a': '.m4a',
    'audio/aac': '.aac',
    'audio/mpeg': '.mp3',
    'audio/ogg': '.ogg',
    'audio/opus': '.opus',
    'audio/webm': '.webm',
    'audio/wav': '.wav',
    'audio/x-wav': '.wav',
  };
  final known = byType[a.contentType.toLowerCase()];
  if (known != null) return known;
  final dot = a.name.lastIndexOf('.');
  if (dot > 0 && a.name.length - dot <= 6) return a.name.substring(dot).toLowerCase();
  return a.kind == 'audio' ? '.m4a' : '.jpg';
}

/// No local store: attachments are read from the server every time, as before.
class NoopChatMediaStore implements ChatMediaStore {
  const NoopChatMediaStore();

  @override
  Future<String?> localFor(ChatAttachment a) async => null;

  @override
  Future<String> fetch(ChatAttachment a) async => throw const MediaGone();

  @override
  Future<void> keep(ChatAttachment a, String sourcePath) async {}

  @override
  Future<void> clear() async {}
}
