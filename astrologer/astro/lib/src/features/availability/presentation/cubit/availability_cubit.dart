import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_paths.dart';

class AvailabilitySnapshot {
  const AvailabilitySnapshot({
    this.loading = true,
    this.presence = 'offline',
    this.channels = const [],
    this.maxConcurrent = 1,
  });
  final bool loading;
  final String presence;
  final List<String> channels;
  final int maxConcurrent;

  AvailabilitySnapshot copyWith({
    bool? loading,
    String? presence,
    List<String>? channels,
    int? maxConcurrent,
  }) =>
      AvailabilitySnapshot(
        loading: loading ?? this.loading,
        presence: presence ?? this.presence,
        channels: channels ?? this.channels,
        maxConcurrent: maxConcurrent ?? this.maxConcurrent,
      );
}

class AvailabilityCubit extends Cubit<AvailabilitySnapshot> {
  AvailabilityCubit(this._dio) : super(const AvailabilitySnapshot());
  final Dio _dio;

  Future<void> load() async {
    try {
      final res =
          await _dio.get<Map<String, dynamic>>(ApiPaths.astroAvailability);
      final d = res.data ?? const {};
      emit(state.copyWith(
        loading: false,
        presence: d['presence_state'] as String? ?? 'offline',
        channels: (d['channels_enabled'] as List? ?? const [])
            .map((e) => e.toString())
            .toList(),
        maxConcurrent: (d['max_concurrent_chats'] as num?)?.toInt() ?? 1,
      ));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> update({List<String>? channels, int? maxConcurrent}) async {
    try {
      await _dio.put(ApiPaths.astroAvailability, data: {
        if (channels != null) 'channels_enabled': channels,
        if (maxConcurrent != null) 'max_concurrent_chats': maxConcurrent,
      });
      await load();
    } catch (_) {}
  }
}
