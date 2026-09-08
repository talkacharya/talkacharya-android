import 'package:equatable/equatable.dart';

/// A tiny "one async slice" holder used by [HomeCubit] so every home section
/// loads, succeeds and fails on its own. Not a replacement for a full bloc —
/// just enough state for a section that fetches once and can retry.
enum AsyncStatus { idle, loading, data, error }

class AsyncValue<T> extends Equatable {
  const AsyncValue._(this.status, this.value, this.error);

  const AsyncValue.idle() : this._(AsyncStatus.idle, null, null);
  const AsyncValue.loading([T? previous])
    : this._(AsyncStatus.loading, previous, null);
  const AsyncValue.data(T value) : this._(AsyncStatus.data, value, null);
  const AsyncValue.error(String error, [T? previous])
    : this._(AsyncStatus.error, previous, error);

  final AsyncStatus status;
  final T? value;
  final String? error;

  bool get isLoading => status == AsyncStatus.loading;
  bool get isError => status == AsyncStatus.error;
  bool get hasValue => value != null;

  R when<R>({
    required R Function() loading,
    required R Function(T value) data,
    required R Function(String message) error,
    R Function()? idle,
  }) {
    switch (status) {
      case AsyncStatus.idle:
        return (idle ?? loading)();
      case AsyncStatus.loading:
        return value == null ? loading() : data(value as T);
      case AsyncStatus.data:
        return data(value as T);
      case AsyncStatus.error:
        return error(this.error ?? 'Something went wrong');
    }
  }

  @override
  List<Object?> get props => [status, value, error];
}
