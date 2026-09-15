import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper over `app_links`. Surfaces the cold-start link once and a stream
/// of links received while the app is running. Consumers translate URIs to
/// locations via `deep_link_parser`.
class DeepLinkService {
  DeepLinkService([AppLinks? appLinks]) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  final _controller = StreamController<Uri>.broadcast();
  Stream<Uri> get uris => _controller.stream;

  bool _initialConsumed = false;

  /// The URI the app was launched with, if any. Returns it only once.
  Future<Uri?> initialLink() async {
    if (_initialConsumed) return null;
    _initialConsumed = true;
    try {
      return await _appLinks.getInitialLink();
    } catch (e) {
      debugPrint('DeepLinkService: getInitialLink failed ($e)');
      return null;
    }
  }

  void start() {
    _sub ??= _appLinks.uriLinkStream.listen(
      _controller.add,
      onError: (Object e) => debugPrint('DeepLinkService: stream error ($e)'),
    );
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _controller.close();
  }
}
