import '../../../../core/usecase/usecase.dart';
import '../entities/legal_document_entity.dart';

abstract class LegalDocumentRepository {
  ResultFuture<LegalDocumentEntity> getLegalDocument(String type);
}
