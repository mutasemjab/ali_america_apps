import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/clip_coupon_usecase.dart';
import '../../domain/usecases/get_coupons_usecase.dart';
import 'coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final GetCouponsUseCase _getCouponsUseCase;
  final ClipCouponUseCase _clipCouponUseCase;

  CouponsCubit(this._getCouponsUseCase, this._clipCouponUseCase) : super(const CouponsState());

  Future<void> load() async {
    emit(state.copyWith(status: CouponsStatus.loading));
    final result = await _getCouponsUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: CouponsStatus.error, errorMessage: failure.message)),
      (coupons) => emit(state.copyWith(status: CouponsStatus.loaded, coupons: coupons)),
    );
  }

  /// Returns an error message on failure so the UI can show a snackbar;
  /// null means it succeeded (or was already clipped, per the API's
  /// idempotent clip semantics).
  Future<String?> clip(int couponId) async {
    emit(state.copyWith(clippingIds: {...state.clippingIds, couponId}));
    final result = await _clipCouponUseCase(ClipCouponParams(couponId));

    String? error;
    result.fold((failure) => error = failure.message, (updated) {
      final coupons = state.coupons.map((c) => c.id == couponId ? updated : c).toList();
      emit(state.copyWith(coupons: coupons));
    });

    emit(state.copyWith(clippingIds: {...state.clippingIds}..remove(couponId)));
    return error;
  }
}
