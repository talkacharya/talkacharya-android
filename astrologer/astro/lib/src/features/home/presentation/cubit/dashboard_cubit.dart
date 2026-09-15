import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_paths.dart';

class DashboardData {
  const DashboardData({
    this.loading = true,
    this.requested = 0,
    this.completed = 0,
    this.acceptanceRate = 0,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.availableToPay = '0',
    this.currency = 'INR',
    this.incomingCount = 0,
  });
  final bool loading;
  final int requested;
  final int completed;
  final double acceptanceRate;
  final double ratingAvg;
  final int ratingCount;
  final String availableToPay;
  final String currency;
  final int incomingCount;

  DashboardData copyWith({
    bool? loading,
    int? requested,
    int? completed,
    double? acceptanceRate,
    double? ratingAvg,
    int? ratingCount,
    String? availableToPay,
    String? currency,
    int? incomingCount,
  }) => DashboardData(
    loading: loading ?? this.loading,
    requested: requested ?? this.requested,
    completed: completed ?? this.completed,
    acceptanceRate: acceptanceRate ?? this.acceptanceRate,
    ratingAvg: ratingAvg ?? this.ratingAvg,
    ratingCount: ratingCount ?? this.ratingCount,
    availableToPay: availableToPay ?? this.availableToPay,
    currency: currency ?? this.currency,
    incomingCount: incomingCount ?? this.incomingCount,
  );
}

class DashboardCubit extends Cubit<DashboardData> {
  DashboardCubit(this._dio) : super(const DashboardData());
  final Dio _dio;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    try {
      final results = await Future.wait([
        _dio.get<Map<String, dynamic>>(
          ApiPaths.astroAnalytics,
          queryParameters: {'days': 7},
        ),
        _dio.get<Map<String, dynamic>>(ApiPaths.astroEarnings),
        _dio.get<dynamic>(ApiPaths.astroConsultationRequests),
      ]);
      final dash = results[0].data as Map<String, dynamic>? ?? const {};
      final cons = (dash['consultations'] as Map?) ?? const {};
      final rating = (dash['rating'] as Map?) ?? const {};
      final earn =
          ((results[1].data as Map?)?['by_currency'] as List?) ?? const [];
      final first = earn.isNotEmpty ? (earn.first as Map) : const {};
      final incoming = (results[2].data as List?) ?? const [];

      emit(
        DashboardData(
          loading: false,
          requested: (cons['requested'] as num?)?.toInt() ?? 0,
          completed: (cons['completed'] as num?)?.toInt() ?? 0,
          acceptanceRate: (cons['acceptance_rate'] as num?)?.toDouble() ?? 0,
          ratingAvg: (rating['avg'] as num?)?.toDouble() ?? 0,
          ratingCount: (rating['count'] as num?)?.toInt() ?? 0,
          availableToPay: '${first['available_to_pay'] ?? '0'}',
          currency: '${first['currency'] ?? 'INR'}',
          incomingCount: incoming.length,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }
}
