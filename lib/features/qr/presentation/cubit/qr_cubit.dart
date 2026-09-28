import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_qrs_usecase.dart';
import 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  final GetQrsUseCase _getQrsUseCase;

  QrCubit(this._getQrsUseCase) : super(const QrState());

  Future<void> load() async {
    emit(const QrState(status: QrStatus.loading));
    final result = await _getQrsUseCase(const NoParams());
    result.fold(
      (failure) => emit(QrState(status: QrStatus.error, errorMessage: failure.message)),
      (qrs) => emit(QrState(status: QrStatus.loaded, qrs: qrs)),
    );
  }
}
