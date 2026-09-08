import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Coarse online/offline signal. `true` == at least one transport is up (does
/// not guarantee the API is reachable, just that the radio is on).
class ConnectivityService extends ValueNotifier<bool> {
  ConnectivityService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity(),
      super(true) {
    _init();
  }

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<void> _init() async {
    try {
      _apply(await _connectivity.checkConnectivity());
      _sub = _connectivity.onConnectivityChanged.listen(_apply);
    } catch (e) {
      debugPrint('ConnectivityService: init failed ($e)');
    }
  }

  void _apply(List<ConnectivityResult> results) {
    value = results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
