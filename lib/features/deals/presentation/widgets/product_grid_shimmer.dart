import 'package:flutter/material.dart';

import '../../../../core/widgets/shimmer_box.dart';

class ProductGridShimmer extends StatelessWidget {
  final int count;

  const ProductGridShimmer({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.56,
      ),
      itemBuilder: (context, index) {
        return const ShimmerBox(borderRadius: BorderRadius.all(Radius.circular(18)));
      },
    );
  }
}
