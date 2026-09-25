import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_call/src/engine/sdp.dart';

/// A cut-down but realistically shaped audio offer, as libwebrtc writes them.
const _audioSdp =
    'v=0\r\n'
    'o=- 46 2 IN IP4 127.0.0.1\r\n'
    's=-\r\n'
    't=0 0\r\n'
    'm=audio 9 UDP/TLS/RTP/SAVPF 111 103\r\n'
    'c=IN IP4 0.0.0.0\r\n'
    'a=rtpmap:111 opus/48000/2\r\n'
    'a=fmtp:111 minptime=10;useinbandfec=1\r\n'
    'a=rtpmap:103 ISAC/16000\r\n';

Map<String, String> _fmtpParams(String sdp, String payload) {
  final line = sdp
      .split(RegExp(r'\r?\n'))
      .firstWhere((l) => l.startsWith('a=fmtp:$payload '));
  final params = <String, String>{};
  for (final part in line.substring('a=fmtp:$payload '.length).split(';')) {
    final eq = part.indexOf('=');
    params[eq < 0 ? part : part.substring(0, eq)] = eq < 0
        ? ''
        : part.substring(eq + 1);
  }
  return params;
}

void main() {
  test('asks for DTX and in-band FEC, keeping what was already there', () {
    final params = _fmtpParams(tuneOpus(_audioSdp), '111');

    expect(params['usedtx'], '1');
    expect(params['useinbandfec'], '1');
    // libwebrtc's own minptime must survive — it is not ours to drop.
    expect(params['minptime'], '10');
  });

  test('writes an fmtp line for an Opus payload that has none', () {
    const bare =
        'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n'
        'a=rtpmap:111 opus/48000/2\r\n'
        'a=rtcp-fb:111 transport-cc\r\n';

    final out = tuneOpus(bare);
    final lines = out.split('\r\n');

    expect(_fmtpParams(out, '111')['usedtx'], '1');
    // Directly under its rtpmap, where an SDP reader expects it.
    expect(lines[1], 'a=rtpmap:111 opus/48000/2');
    expect(lines[2], startsWith('a=fmtp:111 '));
  });

  test('leaves other codecs alone', () {
    final out = tuneOpus(_audioSdp);
    expect(out, contains('a=rtpmap:103 ISAC/16000'));
    expect(out, isNot(contains('a=fmtp:103')));
  });

  test('a video-only description is returned untouched', () {
    const video =
        'm=video 9 UDP/TLS/RTP/SAVPF 96\r\n'
        'a=rtpmap:96 VP8/90000\r\n';
    expect(tuneOpus(video), video);
    expect(tuneOpus(''), '');
  });

  test('running twice changes nothing the second time', () {
    final once = tuneOpus(_audioSdp);
    expect(tuneOpus(once), once);
  });

  test('line endings are preserved', () {
    expect(tuneOpus(_audioSdp), contains('\r\n'));
    final unix = _audioSdp.replaceAll('\r\n', '\n');
    expect(tuneOpus(unix), isNot(contains('\r')));
  });

  test('the bitrate ceiling is only set when asked for', () {
    expect(_fmtpParams(tuneOpus(_audioSdp), '111'), isNot(contains('maxaveragebitrate')));
    expect(
      _fmtpParams(tuneOpus(_audioSdp, maxAverageBitrate: 24000), '111')['maxaveragebitrate'],
      '24000',
    );
  });
}
