import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class FeatureTile {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FeatureTile({required this.icon, required this.label, required this.onTap});
}

/// The 6-tile launcher grid on Home. Rounded cards, soft shadow, a light
/// press animation, and a staggered fade/slide entrance on first load.
class FeatureTileGrid extends StatelessWidget {
  final List<FeatureTile> tiles;

  const FeatureTileGrid({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final tile = tiles[index];
        return _AnimatedTile(tile: tile, index: index);
      },
    );
  }
}

class _AnimatedTile extends StatefulWidget {
  final FeatureTile tile;
  final int index;

  const _AnimatedTile({required this.tile, required this.index});

  @override
  State<_AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<_AnimatedTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.tile.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.tile.icon, color: AppColors.primaryDark, size: 26),
              ),
              const SizedBox(height: 10),
              Text(widget.tile.label, style: AppTextStyles.titleMedium),
            ],
          ),
        ),
      ),
    )
        .animate(delay: (60 * widget.index).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOut);
  }
}
