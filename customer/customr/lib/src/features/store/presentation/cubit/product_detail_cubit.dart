import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/friendly_error.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../../core/util/async_value.dart';
import '../../../consultations/data/consultation_api.dart'
    show InsufficientBalance;
import '../../data/models/cart.dart';
import '../../data/models/consult.dart';
import '../../data/models/product.dart';
import '../../data/models/store_json.dart';
import '../../data/store_api.dart';
import '../../data/store_repository.dart';
import 'cart_cubit.dart';

/// What happened when the customer tried to add to cart.
sealed class AddOutcome {
  const AddOutcome();
}

class AddedToCart extends AddOutcome {
  const AddedToCart(this.cart);
  final Cart cart;
}

/// Local or server validation failed — errors are on the state.
class AddInvalid extends AddOutcome {
  const AddInvalid();
}

class AddNeedsConsult extends AddOutcome {
  const AddNeedsConsult();
}

class AddFailed extends AddOutcome {
  const AddFailed(this.message);
  final String message;
}

/// Error keys that aren't a form field.
const kEventErrorKey = '__event';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({
    required StoreRepository repo,
    required CartCubit cart,
    required String slug,
    String? recommendationId,
    Stream<RealtimeEvent>? realtime,
  }) : _repo = repo,
       _cart = cart,
       _slug = slug,
       super(ProductDetailState(recommendationId: recommendationId)) {
    _sub = realtime?.listen((e) {
      if (e is StoreConsultVerdict) load(silent: true);
    });
  }

  final StoreRepository _repo;
  final CartCubit _cart;
  final String _slug;
  StreamSubscription<RealtimeEvent>? _sub;

  static const maxLineQuantity = 20;

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      emit(state.copyWith(product: AsyncValue.loading(state.product.value)));
    }
    try {
      final p = await _repo.product(
        _slug,
        recommendationId: state.recommendationId,
      );
      emit(_withDefaults(p));
    } catch (e) {
      emit(
        state.copyWith(
          product: AsyncValue.error(friendlyError(e), state.product.value),
        ),
      );
    }
  }

  ProductDetailState _withDefaults(ProductDetail p) {
    final verdict = p.consult.latest?.verdict;
    final positiveForThis =
        verdict != null &&
        verdict.kind == VerdictKind.suitable &&
        verdict.recommendationId != null;
    final preferredVariant = positiveForThis
        ? verdict.recommendedVariantId
        : null;
    String? variantId = state.variantId;
    if (variantId == null || p.variants.every((v) => v.id != variantId)) {
      variantId =
          p.variants.where((v) => v.id == preferredVariant).firstOrNull?.id ??
          p.variants.where((v) => v.inStock).firstOrNull?.id ??
          p.variants.firstOrNull?.id;
    }
    String? eventId = state.eventId;
    if (eventId == null || p.events.every((e) => e.id != eventId)) {
      eventId = p.events.where((e) => e.isOpen).firstOrNull?.id;
    }
    return state.copyWith(
      product: AsyncValue.data(p),
      variantId: variantId,
      eventId: eventId,
      recommendationId:
          state.recommendationId ??
          (positiveForThis ? verdict.recommendationId : null),
    );
  }

  void selectVariant(String id) {
    final p = state.product.value;
    final v = p?.variants.where((v) => v.id == id).firstOrNull;
    if (v == null) return;
    final max = v.maxQuantity(maxLineQuantity);
    emit(
      state.copyWith(
        variantId: id,
        quantity: state.quantity.clamp(1, max),
        errors: const {},
      ),
    );
  }

  void selectEvent(String id) => emit(
    state.copyWith(
      eventId: id,
      errors: {...state.errors}..remove(kEventErrorKey),
    ),
  );

  void setQuantity(int q) {
    final max = state.variant?.maxQuantity(maxLineQuantity) ?? 1;
    emit(state.copyWith(quantity: q.clamp(1, max)));
  }

  void setInput(String key, Object? value) => emit(
    state.copyWith(
      inputs: {...state.inputs, key: value},
      errors: {...state.errors}..remove(key),
    ),
  );

  /// Local check before hitting the server (the server validates again).
  Map<String, String> validate({
    required String Function(String label) requiredMsg,
    required String Function(String label, int count) participantsMsg,
    required String pickDateMsg,
  }) {
    final p = state.product.value;
    if (p == null) return const {};
    final errors = <String, String>{};
    final participants = state.variant?.participants ?? 1;
    for (final f in p.inputSchema) {
      final raw = state.inputs[f.key];
      if (f.perParticipant) {
        final values = raw is List
            ? raw.where((v) => '$v'.trim().isNotEmpty).toList()
            : const [];
        if (f.required && values.length < participants) {
          errors[f.key] = participantsMsg(f.label, participants);
        }
      } else if (f.required && (raw == null || '$raw'.trim().isEmpty)) {
        errors[f.key] = requiredMsg(f.label);
      }
    }
    if (p.isService && p.serviceEventRequired && state.eventId == null) {
      errors[kEventErrorKey] = pickDateMsg;
    }
    return errors;
  }

  Future<AddOutcome> addToCart(Map<String, String> localErrors) async {
    final p = state.product.value;
    final v = state.variant;
    if (p == null || v == null) return const AddFailed('');
    if (p.consult.blocksPurchase) return const AddNeedsConsult();
    if (localErrors.isNotEmpty) {
      emit(state.copyWith(errors: localErrors));
      return const AddInvalid();
    }
    emit(state.copyWith(adding: true, errors: const {}));
    try {
      final participants = v.participants;
      final inputs = <String, dynamic>{
        for (final f in p.inputSchema)
          if (state.inputs[f.key] != null)
            f.key: f.perParticipant && state.inputs[f.key] is List
                ? (state.inputs[f.key] as List).take(participants).toList()
                : state.inputs[f.key],
      };
      final cart = await _cart.add(
        variantId: v.id,
        quantity: p.isService ? 1 : state.quantity,
        inputs: inputs,
        eventId: p.isService ? state.eventId : null,
        recommendationId: state.recommendationId,
      );
      emit(state.copyWith(adding: false));
      return AddedToCart(cart);
    } on StoreInputsInvalid catch (e) {
      emit(state.copyWith(adding: false, errors: e.fields));
      return const AddInvalid();
    } on StoreConsultRequired {
      emit(state.copyWith(adding: false));
      return const AddNeedsConsult();
    } on InsufficientBalance {
      emit(state.copyWith(adding: false));
      return const AddFailed('');
    } catch (e) {
      emit(state.copyWith(adding: false));
      return AddFailed(friendlyError(e));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.product = const AsyncValue.idle(),
    this.variantId,
    this.eventId,
    this.quantity = 1,
    this.inputs = const {},
    this.errors = const {},
    this.adding = false,
    this.recommendationId,
  });

  final AsyncValue<ProductDetail> product;
  final String? variantId;
  final String? eventId;
  final int quantity;
  final Json inputs;

  /// field key (or [kEventErrorKey]) → message
  final Map<String, String> errors;
  final bool adding;

  /// Buying through an astrologer's recommendation (affiliate + gate clearance).
  final String? recommendationId;

  ProductVariant? get variant =>
      product.value?.variants.where((v) => v.id == variantId).firstOrNull;

  ServiceEvent? get event =>
      product.value?.events.where((e) => e.id == eventId).firstOrNull;

  double? get price => variant?.price ?? product.value?.card.priceFrom;

  ProductDetailState copyWith({
    AsyncValue<ProductDetail>? product,
    String? variantId,
    String? eventId,
    int? quantity,
    Json? inputs,
    Map<String, String>? errors,
    bool? adding,
    String? recommendationId,
  }) => ProductDetailState(
    product: product ?? this.product,
    variantId: variantId ?? this.variantId,
    eventId: eventId ?? this.eventId,
    quantity: quantity ?? this.quantity,
    inputs: inputs ?? this.inputs,
    errors: errors ?? this.errors,
    adding: adding ?? this.adding,
    recommendationId: recommendationId ?? this.recommendationId,
  );

  @override
  List<Object?> get props => [
    product,
    variantId,
    eventId,
    quantity,
    inputs,
    errors,
    adding,
    recommendationId,
  ];
}
