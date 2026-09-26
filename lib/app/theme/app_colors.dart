import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Palette
  static const Color backgroundLight = Color(0xFFFDFBF7); // Warm Ivory
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF8F4EE); // Soft Cream
  static const Color secondaryCardLight = Color(0xFFF3ECE2); // Warm Sand
  static const Color blushLight = Color(0xFFFAECEB); // Light Blush
  
  // Accents
  static const Color primaryRose = Color(0xFFC07070); // Muted Elegant Rose
  static const Color primaryRoseDark = Color(0xFFA65858);
  static const Color roseSoft = Color(0xFFE8AEAE);
  static const Color champagneGold = Color(0xFFC5A059); // Champagne Gold
  static const Color champagneGoldLight = Color(0xFFE8D3A2);
  static const Color goldAccent = Color(0xFFD4AF37);
  
  // Neutral Text & Borders
  static const Color textPrimaryLight = Color(0xFF1B1918); // Deep Charcoal
  static const Color textSecondaryLight = Color(0xFF6B6661); // Warm Muted Gray
  static const Color textTertiaryLight = Color(0xFF9E9891);
  static const Color borderLight = Color(0xFFEAE3D9); // Subtle Warm Border
  static const Color dividerLight = Color(0xFFF0EBE3);

  // Dark Theme Palette
  static const Color backgroundDark = Color(0xFF121110); // Obsidian Warm Dark
  static const Color surfaceDark = Color(0xFF1B1918);
  static const Color cardDark = Color(0xFF242220); // Dark Elevated Surface
  static const Color secondaryCardDark = Color(0xFF2E2B28);
  static const Color textPrimaryDark = Color(0xFFF8F5F0);
  static const Color textSecondaryDark = Color(0xFFA8A29A);
  static const Color textTertiaryDark = Color(0xFF736D66);
  static const Color borderDark = Color(0xFF332F2B);
  static const Color dividerDark = Color(0xFF2B2825);
  
  // Functional Colors
  static const Color success = Color(0xFF4E9F76);
  static const Color error = Color(0xFFD9534F);
  static const Color warning = Color(0xFFE5A642);
  static const Color starFilled = Color(0xFFE0A938);
  static const Color starEmpty = Color(0xFFDCD6CE);
  
  // Gradient Presets
  static const LinearGradient luxuryGoldGradient = LinearGradient(
    colors: [Color(0xFFE3C588), Color(0xFFC5A059)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGoldGradient = LinearGradient(
    colors: [Color(0xFFE8AEAE), Color(0xFFC07070)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    colors: [Color(0xFF2C2623), Color(0xFF141211)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softBlushGradient = LinearGradient(
    colors: [Color(0xFFFFF7F6), Color(0xFFF8EBEA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
