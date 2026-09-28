import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'shimmer_box.dart';

/// Cached network image with a shimmer placeholder shaped like the final
/// image and a graceful broken-image fallback — used everywhere a remote
/// image appears.
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: width,
          height: height,
          color: AppColors.surfaceMuted,
          child: const Icon(Icons.image_outlined, color: AppColors.textSecondary),
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => ShimmerBox(
          width: width,
          height: height,
          borderRadius: borderRadius,
        ),
        errorWidget: (_, __, ___) => Container(
          width: width,
          height: height,
          color: AppColors.surfaceMuted,
          child: const Icon(Icons.broken_image_outlined, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
