import 'package:equatable/equatable.dart';

abstract class DealsEvent extends Equatable {
  const DealsEvent();

  @override
  List<Object?> get props => [];
}

class DealsStarted extends DealsEvent {
  const DealsStarted();
}

class DealsCategorySelected extends DealsEvent {
  final int? categoryId;
  const DealsCategorySelected(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class DealsRefreshed extends DealsEvent {
  const DealsRefreshed();
}

class DealsMoreRequested extends DealsEvent {
  const DealsMoreRequested();
}
