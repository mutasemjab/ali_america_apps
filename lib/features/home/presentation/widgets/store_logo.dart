import 'package:flutter/material.dart';

/// The store's actual logo, bundled locally as assets/icon.png (the same
/// artwork used for the launcher icon) — shown directly instead of a
/// generic storefront icon or a network-fetched image.
class StoreLogo extends StatelessWidget {
  final double size;

  const StoreLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icon.png',
      height: size,
      fit: BoxFit.contain,
    );
  }
}
