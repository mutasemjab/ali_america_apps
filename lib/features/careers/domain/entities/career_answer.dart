import 'package:equatable/equatable.dart';

/// One answer to one specification, keyed by the spec's id in the request
/// (`answers[{id}]`). A text/select answer carries [text]; a file answer
/// carries [filePath]/[fileName] instead — never both, kept in the domain
/// layer so it stays dio/FormData-agnostic.
class CareerAnswer extends Equatable {
  final String? text;
  final String? filePath;
  final String? fileName;

  const CareerAnswer.text(this.text)
      : filePath = null,
        fileName = null;

  const CareerAnswer.file(this.filePath, this.fileName) : text = null;

  bool get isFile => filePath != null;

  @override
  List<Object?> get props => [text, filePath, fileName];
}
