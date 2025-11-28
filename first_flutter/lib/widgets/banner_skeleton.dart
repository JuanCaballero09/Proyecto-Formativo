import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget de carga skeleton para banners
/// Muestra una animación de barrido gris mientras se cargan los datos
class BannerSkeleton extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const BannerSkeleton({
    super.key,
    this.height = 200,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      period: const Duration(milliseconds: 1500),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Widget de carga skeleton para el carrusel completo de banners
class BannerCarouselSkeleton extends StatelessWidget {
  const BannerCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Banner skeleton
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BannerSkeleton(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          // Indicadores skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
