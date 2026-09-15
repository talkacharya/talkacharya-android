import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/brand_colors.dart';

/// A rounded placeholder block. Wrap a tree of these in [AppShimmer] to get the
/// loading shimmer. Mirrors the home feed's `SkeletonBox` so loading states
/// look the same across the app.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({this.width, this.height = 12, this.radius = 6, super.key});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Shimmer tuned to the warm brand palette (light + dark).
class AppShimmer extends StatelessWidget {
  const AppShimmer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Shimmer.fromColors(
      baseColor: brand.shimmerBase,
      highlightColor: brand.shimmerHighlight,
      child: child,
    );
  }
}
