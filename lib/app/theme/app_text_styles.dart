import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Brand & Editorial Headings
  static TextStyle brandLogo({bool isDark = false, double fontSize = 26}) {
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 4.0,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
  }

  static TextStyle heroHeading({bool isDark = false, double fontSize = 32}) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      height: 1.2,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
  }

  static TextStyle sectionHeading({bool isDark = false, double fontSize = 20}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
  }

  static TextStyle subHeading({bool isDark = false, double fontSize = 16}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );
  }

  // Product & Content
  static TextStyle productName({bool isDark = false, double fontSize = 15}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      height: 1.25,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
  }

  static TextStyle productBrand({bool isDark = false, double fontSize = 12}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: AppColors.champagneGold,
    );
  }

  static TextStyle priceLarge({bool isDark = false, double fontSize = 22}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
  }

  static TextStyle priceRegular({bool isDark = false, double fontSize = 16}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
  }

  static TextStyle originalPrice({bool isDark = false, double fontSize = 13}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
      decorationColor: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
    );
  }

  static TextStyle discountBadge({double fontSize = 11}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: AppColors.primaryRose,
    );
  }

  // Body & Details
  static TextStyle bodyLarge({bool isDark = false, double fontSize = 16}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
    );
  }

  static TextStyle bodyMedium({bool isDark = false, double fontSize = 14}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );
  }

  static TextStyle bodySmall({bool isDark = false, double fontSize = 12}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      height: 1.35,
      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
    );
  }

  static TextStyle button({double fontSize = 15, Color? color}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      color: color ?? Colors.white,
    );
  }

  static TextStyle tag({bool isDark = false, double fontSize = 11}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );
  }
}
