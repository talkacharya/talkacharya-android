import 'package:connectivity_plus/connectivity_plus.dart';

import '../ports/call_ports.dart';

/// [CallConnectivity] on `connectivity_plus`.
///
/// Only reports an *actual* change of the active network. The platform stream
/// replays the current network to a new listener on some platforms, which is
/// not a change — the first event establishes the baseline and is swallowed,
/// so a call doesn't renegotiate the instant its screen opens.
class ConnectivityPlusCallConnectivity implements CallConnectivity {
  const ConnectivityPlusCallConnectivity();

  @override
  Stream<void> get changes {
    Set<String>? previous;
    return Connectivity().onConnectivityChanged
        .where((result) {
          final current = {for (final r in result) r.name};
          final last = previous;
          previous = current;
          if (last == null) return false;
          return last.length != current.length || !last.containsAll(current);
        })
        .map((_) {});
  }
}
