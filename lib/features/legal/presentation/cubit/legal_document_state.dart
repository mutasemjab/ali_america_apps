import 'package:equatable/equatable.dart';

enum LegalDocumentStatus { loading, loaded, error }

class LegalDocumentState extends Equatable {
  final LegalDocumentStatus status;
  final String content;
  final String? errorMessage;

  const LegalDocumentState({
    this.status = LegalDocumentStatus.loading,
    this.content = '',
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, content, errorMessage];
}
