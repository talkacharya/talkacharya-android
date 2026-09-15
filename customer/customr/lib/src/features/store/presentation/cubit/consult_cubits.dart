import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/async_value.dart';
import '../../../consultations/data/consultation_api.dart'
    show AstrologerBusy, AstrologerOffline, InsufficientBalance;
import '../../data/models/consult.dart';
import '../../data/models/product.dart';
import '../../data/store_repository.dart';

// --- options + start ------------------------------------------------------------------

sealed class ConsultStartOutcome {
  const ConsultStartOutcome();
}

class ConsultStarted extends ConsultStartOutcome {
  const ConsultStarted(this.consultationId);
  final String consultationId;
}

class ConsultNeedsRecharge extends ConsultStartOutcome {
  const ConsultNeedsRecharge(this.required);

  /// Minimum amount the wallet must hold (one minute), as the backend says.
  final double required;
}

class ConsultAstrologerBusy extends ConsultStartOutcome {
  const ConsultAstrologerBusy();
}

class ConsultAstrologerOffline extends ConsultStartOutcome {
  const ConsultAstrologerOffline();
}

class ConsultStartFailed extends ConsultStartOutcome {
  const ConsultStartFailed(this.message);
  final String message;
}

/// `/store/products/:slug/consult` — who can take a video call about this product.
class ConsultOptionsCubit extends Cubit<ConsultOptionsState> {
  ConsultOptionsCubit({
    required StoreRepository repo,
    required String slug,
    ProductDetail? product,
  }) : _repo = repo,
       _slug = slug,
       super(
         ConsultOptionsState(
           product: product == null
               ? const AsyncValue.idle()
               : AsyncValue.data(product),
         ),
       );

  final StoreRepository _repo;
  final String _slug;

  Future<void> load() async {
    emit(state.copyWith(options: AsyncValue.loading(state.options.value)));
    await Future.wait([
      () async {
        try {
          final o = await _repo.consultOptions(_slug);
          emit(state.copyWith(options: AsyncValue.data(o)));
        } catch (e) {
          emit(
            state.copyWith(
              options: AsyncValue.error(friendlyError(e), state.options.value),
            ),
          );
        }
      }(),
      if (!state.product.hasValue)
        () async {
          try {
            final p = await _repo.product(_slug);
            emit(state.copyWith(product: AsyncValue.data(p)));
          } catch (e) {
            emit(state.copyWith(product: AsyncValue.error(friendlyError(e))));
          }
        }(),
    ]);
  }

  Future<ConsultStartOutcome> start({
    required ConsultAstrologer astrologer,
    String question = '',
    String? birthProfileId,
  }) async {
    final product = state.product.value;
    if (product == null || state.startingId != null) {
      return const ConsultStartFailed('');
    }
    emit(state.copyWith(startingId: astrologer.id));
    try {
      final started = await _repo.startConsult(
        product: product,
        astrologerId: astrologer.id,
        variantId: state.variantId,
        channel: state.options.value?.channel,
        question: question,
        birthProfileId: birthProfileId,
      );
      return ConsultStarted(started.consultation.id);
    } on InsufficientBalance catch (e) {
      return ConsultNeedsRecharge(
        double.tryParse(e.required) ?? astrologer.ratePerMinute,
      );
    } on AstrologerBusy {
      await load();
      return const ConsultAstrologerBusy();
    } on AstrologerOffline {
      await load();
      return const ConsultAstrologerOffline();
    } catch (e) {
      return ConsultStartFailed(friendlyError(e));
    } finally {
      emit(state.copyWith(clearStarting: true));
    }
  }

  void setVariant(String? id) => emit(state.copyWith(variantId: id));
}

class ConsultOptionsState extends Equatable {
  const ConsultOptionsState({
    this.options = const AsyncValue.idle(),
    this.product = const AsyncValue.idle(),
    this.startingId,
    this.variantId,
  });

  final AsyncValue<ConsultOptions> options;
  final AsyncValue<ProductDetail> product;

  /// Astrologer whose call is being requested.
  final String? startingId;
  final String? variantId;

  ConsultOptionsState copyWith({
    AsyncValue<ConsultOptions>? options,
    AsyncValue<ProductDetail>? product,
    String? startingId,
    String? variantId,
    bool clearStarting = false,
  }) => ConsultOptionsState(
    options: options ?? this.options,
    product: product ?? this.product,
    startingId: clearStarting ? null : (startingId ?? this.startingId),
    variantId: variantId ?? this.variantId,
  );

  @override
  List<Object?> get props => [options, product, startingId, variantId];
}

// --- advice list + detail -------------------------------------------------------------

class ConsultsCubit extends Cubit<AsyncValue<List<StoreConsult>>> {
  ConsultsCubit(this._repo) : super(const AsyncValue.idle());

  final StoreRepository _repo;

  Future<void> load() async {
    emit(AsyncValue.loading(state.value));
    try {
      emit(AsyncValue.data(await _repo.consults()));
    } catch (e) {
      emit(AsyncValue.error(friendlyError(e), state.value));
    }
  }
}

class ConsultDetailCubit extends Cubit<AsyncValue<StoreConsult>> {
  ConsultDetailCubit({required StoreRepository repo, required String id})
    : _repo = repo,
      _id = id,
      super(const AsyncValue.idle());

  final StoreRepository _repo;
  final String _id;

  Future<void> load() async {
    emit(AsyncValue.loading(state.value));
    try {
      emit(AsyncValue.data(await _repo.consult(_id)));
    } catch (e) {
      emit(AsyncValue.error(friendlyError(e), state.value));
    }
  }
}
