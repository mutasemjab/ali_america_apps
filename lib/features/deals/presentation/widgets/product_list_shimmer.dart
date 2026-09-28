import 'package:flutter/material.dart';

import '../../../../core/widgets/shimmer_box.dart';

class ProductListShimmer extends StatelessWidget {
  final int count;

  const ProductListShimmer({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: count,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const ShimmerBox(height: 128, borderRadius: BorderRadius.all(Radius.circular(16)));
      },
    );
  }
}
