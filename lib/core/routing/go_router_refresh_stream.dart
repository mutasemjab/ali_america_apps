import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts a [Listenable] (our [AuthSession]) into the [Stream]-shaped
/// refresh source go_router's `refreshListenable` expects.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<void> _subscription;

  GoRouterRefreshStream(Listenable listenable) {
    notifyListeners();
    _subscription = _toStream(listenable).listen((_) => notifyListeners());
  }

  Stream<void> _toStream(Listenable listenable) {
    final controller = StreamController<void>.broadcast();
    void listener() => controller.add(null);
    listenable.addListener(listener);
    controller.onCancel = () => listenable.removeListener(listener);
    return controller.stream;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
