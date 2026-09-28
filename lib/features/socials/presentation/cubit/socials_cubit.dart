import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_socials_usecase.dart';
import 'socials_state.dart';

class SocialsCubit extends Cubit<SocialsState> {
  final GetSocialsUseCase _getSocialsUseCase;

  SocialsCubit(this._getSocialsUseCase) : super(const SocialsState());

  Future<void> load() async {
    emit(const SocialsState(status: SocialsStatus.loading));
    final result = await _getSocialsUseCase(const NoParams());
    result.fold(
      (failure) => emit(SocialsState(status: SocialsStatus.error, errorMessage: failure.message)),
      (socials) => emit(SocialsState(status: SocialsStatus.loaded, socials: socials)),
    );
  }
}
