import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_legal_document_usecase.dart';
import 'legal_document_state.dart';

class LegalDocumentCubit extends Cubit<LegalDocumentState> {
  final GetLegalDocumentUseCase _getLegalDocumentUseCase;

  LegalDocumentCubit(this._getLegalDocumentUseCase) : super(const LegalDocumentState());

  Future<void> load(String type) async {
    emit(const LegalDocumentState(status: LegalDocumentStatus.loading));
    final result = await _getLegalDocumentUseCase(GetLegalDocumentParams(type));
    result.fold(
      (failure) =>
          emit(LegalDocumentState(status: LegalDocumentStatus.error, errorMessage: failure.message)),
      (document) =>
          emit(LegalDocumentState(status: LegalDocumentStatus.loaded, content: document.content)),
    );
  }
}
