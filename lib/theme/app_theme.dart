import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Brand & Accent Colors
  static const Color primaryColor = Color(0xFFFF2A54); // Premium Crimson Accent
  static const Color primaryHoverColor = Color(0xFFE01B42);
  static const Color primaryGradientEnd = Color(0xFFFF523B); // Warm Crimson Flare
  
  // Light Theme System Colors
  static const Color lightBackground = Color(0xFFF8F9FA); // Off-white clean backdrop
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white card surface
  static const Color lightImageContainer = Color(0xFFF1F5F9); // Soft cool neutral shoe container
  static const Color lightTextPrimary = Color(0xFF0F172A); // Deep Obsidian Black
  static const Color lightTextSecondary = Color(0xFF64748B); // Cool Slate Gray
  static const Color lightBorder = Color(0xFFE2E8F0); // Subtle Divider Border

  // Dark Theme System Colors
  static const Color darkBackground = Color(0xFF0B0F17); // Deep Obsidian Slate
  static const Color darkSurface = Color(0xFF161E2E); // Elevated Dark Card Surface
  static const Color darkImageContainer = Color(0xFF1E293B); // Dark neutral shoe container
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Clean Pure White
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate Secondary
  static const Color darkBorder = Color(0xFF2A364F); // Subtle Dark Border

  // Status & Highlight Colors
  static const Color accentGold = Color(0xFFFFB800); // Rating Gold Star
  static const Color emeraldGreen = Color(0xFF10B981); // Success Green / Discount
  static const Color badgeBgLight = Color(0xFFFFF0F3); // Light Crimson Pill

  // Standard Spacing Constants
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 12.0;
  static const double spaceLG = 16.0;
  static const double spaceXL = 20.0;
  static const double spaceXXL = 24.0;
  static const double spaceSection = 32.0;

  // Standard Radius Constants
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 18.0;
  static const double radiusXL = 24.0;

  // Theme Data — Light Mode
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: primaryGradientEnd,
      surface: lightSurface,
      onPrimary: Colors.white,
      onSurface: lightTextPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: lightTextPrimary, fontSize: 32, letterSpacing: -0.5),
      displayMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: lightTextPrimary, fontSize: 26, letterSpacing: -0.4),
      titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: lightTextPrimary, fontSize: 20, letterSpacing: -0.2),
      titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: lightTextPrimary, fontSize: 16),
      titleSmall: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: lightTextPrimary, fontSize: 14),
      bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.normal, color: lightTextPrimary, fontSize: 15),
      bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.normal, color: lightTextSecondary, fontSize: 13),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: lightTextPrimary),
      titleTextStyle: TextStyle(color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLG),
        side: const BorderSide(color: lightBorder, width: 1),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );

  // Theme Data — Dark Mode
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryGradientEnd,
      surface: darkSurface,
      onPrimary: Colors.white,
      onSurface: darkTextPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: darkTextPrimary, fontSize: 32, letterSpacing: -0.5),
      displayMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: darkTextPrimary, fontSize: 26, letterSpacing: -0.4),
      titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: darkTextPrimary, fontSize: 20, letterSpacing: -0.2),
      titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: darkTextPrimary, fontSize: 16),
      titleSmall: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: darkTextPrimary, fontSize: 14),
      bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.normal, color: darkTextPrimary, fontSize: 15),
      bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.normal, color: darkTextSecondary, fontSize: 13),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: darkTextPrimary),
      titleTextStyle: TextStyle(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLG),
        side: const BorderSide(color: darkBorder, width: 1),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );

  // Responsive Grid Column Calculator
  static int getGridColumnCount(double width) {
    if (width < 600) {
      return 2; // Mobile
    } else if (width < 960) {
      return 3; // Tablet
    } else if (width < 1280) {
      return 4; // Laptop/Desktop
    } else {
      return 5; // Wide Display
    }
  }

  // Linear Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroBannerGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card Decoration Helper
  static BoxDecoration cardDecoration(bool isDark, {double borderRadius = radiusLG}) {
    return BoxDecoration(
      color: isDark ? darkSurface : lightSurface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isDark ? darkBorder : lightBorder,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Image Container Background Color Helper
  static Color imageContainerColor(bool isDark) {
    return isDark ? darkImageContainer : lightImageContainer;
  }

  // Image Container Decoration Helper
  static BoxDecoration imageContainerDecoration(bool isDark, {double borderRadius = radiusLG}) {
    return BoxDecoration(
      color: imageContainerColor(isDark),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}


