import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/connectivity/connectivity_cubit.dart';
import 'core/di/injection_container.dart';
import 'core/routing/app_router.dart';
import 'core/session/auth_session.dart';
import 'core/theme/app_theme.dart';

class StoreCompanionApp extends StatelessWidget {
  const StoreCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ConnectivityCubit>(),
      child: MaterialApp.router(
        title: 'Store Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: buildAppRouter(sl<AuthSession>()),
      ),
    );
  }
}
