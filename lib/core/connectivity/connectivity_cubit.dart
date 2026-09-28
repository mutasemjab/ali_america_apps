import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/network_info.dart';

class ConnectivityCubit extends Cubit<bool> {
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? _subscription;

  ConnectivityCubit(this._networkInfo) : super(true) {
    _init();
  }

  Future<void> _init() async {
    emit(await _networkInfo.isConnected);
    _subscription = _networkInfo.onConnectivityChanged.listen(emit);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
