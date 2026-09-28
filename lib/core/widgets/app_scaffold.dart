import 'package:flutter/material.dart';

import 'offline_banner.dart';

/// Wraps a normal Scaffold body with the offline banner so every screen
/// gets consistent "no internet" affordance without repeating the plumbing.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool isOffline;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.isOffline = false,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          OfflineBanner(visible: isOffline),
          Expanded(child: body),
        ],
      ),
    );
  }
}
