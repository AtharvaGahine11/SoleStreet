import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app/theme/app_colors.dart';

class LumoraImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final String? heroTag;

  const LumoraImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 280),
        fadeOutDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.cardDark,
                      AppColors.surfaceDark.withValues(alpha: 0.8),
                      AppColors.cardDark,
                    ]
                  : [
                      AppColors.surfaceLight,
                      AppColors.blushLight.withValues(alpha: 0.4),
                      AppColors.cardLight,
                    ],
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1.8,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.champagneGoldLight : AppColors.champagneGold,
                ),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.cardDark,
                      AppColors.surfaceDark,
                    ]
                  : [
                      AppColors.surfaceLight,
                      AppColors.blushLight.withValues(alpha: 0.5),
                    ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.diamond_outlined,
                size: 26,
                color: (isDark ? AppColors.champagneGoldLight : AppColors.champagneGold)
                    .withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Text(
                'HEERA',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (heroTag != null && heroTag!.isNotEmpty) {
      return Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
