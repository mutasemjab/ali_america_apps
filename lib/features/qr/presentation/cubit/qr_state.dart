import 'package:equatable/equatable.dart';

import '../../domain/entities/qr_entity.dart';

enum QrStatus { loading, loaded, error }

class QrState extends Equatable {
  final QrStatus status;
  final List<QrEntity> qrs;
  final String? errorMessage;

  const QrState({this.status = QrStatus.loading, this.qrs = const [], this.errorMessage});

  @override
  List<Object?> get props => [status, qrs, errorMessage];
}
