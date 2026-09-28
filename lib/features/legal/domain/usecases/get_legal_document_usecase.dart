import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/legal_document_entity.dart';
import '../repositories/legal_document_repository.dart';

class GetLegalDocumentUseCase implements UseCase<LegalDocumentEntity, GetLegalDocumentParams> {
  final LegalDocumentRepository repository;
  GetLegalDocumentUseCase(this.repository);

  @override
  ResultFuture<LegalDocumentEntity> call(GetLegalDocumentParams params) {
    return repository.getLegalDocument(params.type);
  }
}

class GetLegalDocumentParams extends Equatable {
  final String type;
  const GetLegalDocumentParams(this.type);

  @override
  List<Object?> get props => [type];
}
