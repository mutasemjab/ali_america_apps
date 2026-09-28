import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/store_entity.dart';

class SplashState extends Equatable {
  final StoreEntity? store;
  final String? destination;

  const SplashState({this.store, this.destination});

  bool get isReadyToNavigate => destination != null;

  SplashState copyWith({StoreEntity? store, String? destination}) {
    return SplashState(store: store ?? this.store, destination: destination ?? this.destination);
  }

  @override
  List<Object?> get props => [store, destination];
}
