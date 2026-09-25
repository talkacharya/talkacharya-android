/// Opus options we want on every consultation, merged into the SDP.
///
/// * `useinbandfec=1` — the encoder carries a low-bitrate copy of the previous
///   frame inside the next one, so a single lost packet is reconstructed
///   rather than heard as a hole. Mobile networks lose packets constantly.
/// * `usedtx=1` — stop transmitting while nobody is speaking. In a
///   consultation one side is listening most of the time, so this is close to
///   half the audio a relayed call would otherwise push through our own relay.
///
/// These are negotiated per direction: what we put in *our* description tells
/// the far end's encoder what we want it to do. Both apps running this is what
/// turns them on in both directions.
///
/// [maxAverageBitrate] is left unset on purpose. libwebrtc already targets a
/// sensible rate for mono voice and adapts down under congestion; capping it
/// trades clarity for bandwidth, and picking that number wants measurement
/// rather than a guess. The knob is here for when there is one.
String tuneOpus(String sdp, {int? maxAverageBitrate}) {
  if (sdp.isEmpty) return sdp;

  final rtpmap = RegExp(r'^a=rtpmap:(\d+) +opus/', caseSensitive: false);
  final fmtp = RegExp(r'^a=fmtp:(\d+) +(.*)$');

  final eol = sdp.contains('\r\n') ? '\r\n' : '\n';
  final lines = sdp.split(RegExp(r'\r?\n'));

  final payloads = <String>{};
  for (final line in lines) {
    final match = rtpmap.firstMatch(line);
    if (match != null) payloads.add(match.group(1)!);
  }
  if (payloads.isEmpty) return sdp; // no Opus here (a video-only m-line, say)

  final wanted = <String, String>{
    'useinbandfec': '1',
    'usedtx': '1',
    if (maxAverageBitrate != null) 'maxaveragebitrate': '$maxAverageBitrate',
  };

  final out = <String>[];
  final tuned = <String>{};
  // Where each Opus payload's rtpmap ended up, so one can be given an fmtp
  // line of its own if it has none.
  final rtpmapAt = <String, int>{};

  for (final line in lines) {
    final existing = fmtp.firstMatch(line);
    if (existing != null && payloads.contains(existing.group(1))) {
      out.add('a=fmtp:${existing.group(1)} ${_merge(existing.group(2)!, wanted)}');
      tuned.add(existing.group(1)!);
      continue;
    }
    final map = rtpmap.firstMatch(line);
    if (map != null) rtpmapAt[map.group(1)!] = out.length;
    out.add(line);
  }

  // Insert from the bottom up so the earlier positions stay valid.
  final missing = payloads.difference(tuned).toList()
    ..sort((a, b) => (rtpmapAt[b] ?? -1).compareTo(rtpmapAt[a] ?? -1));
  for (final payload in missing) {
    final at = rtpmapAt[payload];
    if (at == null) continue;
    out.insert(at + 1, 'a=fmtp:$payload ${_merge('', wanted)}');
  }

  return out.join(eol);
}

/// Existing parameters keep their order and values; ours are set on top.
String _merge(String existing, Map<String, String> wanted) {
  final params = <String, String>{};
  for (final part in existing.split(';')) {
    final trimmed = part.trim();
    if (trimmed.isEmpty) continue;
    final eq = trimmed.indexOf('=');
    if (eq < 0) {
      params[trimmed] = '';
    } else {
      params[trimmed.substring(0, eq)] = trimmed.substring(eq + 1);
    }
  }
  params.addAll(wanted);
  return params.entries
      .map((e) => e.value.isEmpty ? e.key : '${e.key}=${e.value}')
      .join(';');
}
