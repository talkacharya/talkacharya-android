import 'dart:async';
import 'package:dio/dio.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/realtime/realtime_client.dart';
import '../../../core/firebase/firebase_setup.dart';

/// [CallBackend] over the shared Dio client (`/consultations/{id}/call/*`).
class DioCallBackend implements CallBackend {
  DioCallBackend(this._dio, this.consultationId, {required this.onEnd});

  final Dio _dio;
  final String consultationId;

  /// Ends (or, while still ringing, cancels) the consultation — owned by the room.
  final Future<void> Function() onEnd;

  @override
  Future<CallJoin> join() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/consultations/$consultationId/call/join',
      );
      if ((res.statusCode ?? 0) >= 400) {
        throw ApiException.fromDio(
          DioException(requestOptions: res.requestOptions, response: res),
        );
      }
      return CallJoin.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> reportState(
    CallNetState state, {
    bool? relayed,
    int? quality,
    int? rttMs,
    int? lossPct,
  }) async {
    await _dio.post<void>(
      '/consultations/$consultationId/call/state',
      data: {
        'state': state.name,
        'relayed': ?relayed,
        'quality': ?quality,
        'rtt_ms': ?rttMs,
        'loss_pct': ?lossPct,
      },
    );
  }

  @override
  Future<void> endConsultation() => onEnd();
}

/// [CallSignaling] over the app's Centrifugo client.
class RealtimeCallSignaling implements CallSignaling {
  RealtimeCallSignaling(this._rt);
  final RealtimeClient _rt;

  @override
  Stream<Map<String, dynamic>> frames(String channel) =>
      _rt.channelFrames(channel);

  @override
  Future<void> publish(String channel, Map<String, dynamic> data) =>
      _rt.publishToChannel(channel, data);
}

/// [CallDiagnostics] onto Crashlytics breadcrumbs.
///
/// These ride along with whatever is reported next — a crash, or a non-fatal
/// we record ourselves — so a call that went wrong in the field arrives with
/// its own history attached instead of just a stack trace.
class CrashlyticsCallDiagnostics implements CallDiagnostics {
  const CrashlyticsCallDiagnostics();

  @override
  void log(String message) => unawaited(FirebaseSetup.log('call: $message'));
}
