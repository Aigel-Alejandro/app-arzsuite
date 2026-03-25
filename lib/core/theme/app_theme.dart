import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized application theme adapting styles from styles.scss
class AppTheme {
  // Brand Colors (Logo Gold as Primary)
  static const Color primaryColor = Color(0xFFA3892F); // Dorado Institucional
  static const Color primaryDark = Color(0xFF7A6822);  
  static const Color secondaryColor = Color(0xFF406EBA); // Azul como secundario/acento
  static const Color accentGold = Color(0xFFA3892F);
  static const Color vibrantGold = Color(0xFFB39716);


  // Alert Colors
  static const Color successColor = Color(0xFF43B581);
  static const Color warningColor = Color(0xFFF4D35E);
  static const Color dangerColor = Color(0xFFDA3E3E);

  // Neutral Colors (Softer grays for better UX/UI - Modern 2026 Zinc palette)
  // Minimalist, clean, and elegant. No pure white (#FFFFFF) or pure black (#000000).
  static const Color neutral900 = Color(0xFF141416); // Deep Charcoal Slate (Background Dark)
  static const Color neutral800 = Color(0xFF1D1D21); // Dark Surface
  static const Color neutral700 = Color(0xFF2A2A30); // Elevated Dark Surface / Borders
  static const Color neutral600 = Color(0xFF404046); // Muted Dark
  static const Color neutral500 = Color(0xFF71717A); // Subtext / Icons Dark
  static const Color neutral400 = Color(0xFFA1A1AA); // Subtext Light
  static const Color neutral300 = Color(0xFFD4D4D8); // Disabled / Borders Light
  static const Color neutral200 = Color(0xFFE4E4E7); // Dividers Light
  static const Color neutral100 = Color(0xFFF4F4F5); // Alternative Background Light / Text Dark
  static const Color neutral50 = Color(0xFFFAFAFA);  // Main background light 
  static const Color surfaceColor = Color(0xFFFCFCFD); // High-quality surface (for Cards)


  // Border Radiuses
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0; // .border-radius-custom
  static const double borderRadiusGlobal = 20.0; // --border-global
  static const double borderRadiusLarge = 24.0;

  // Paddings and Margins
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;

  // Responsive Breakpoints (Bootstrap-like)
  static const double breakpointMobile = 576.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 992.0;
  static const double breakpointLargeDesktop = 1200.0;

  // Max Container Widths
  static const double containerMaxWidthTablet = 720.0;
  static const double containerMaxWidthDesktop = 960.0;
  static const double containerMaxWidthLargeDesktop = 1140.0;

  // ---------------------------------------------------------------------------
  // Light Theme
  // ---------------------------------------------------------------------------
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor, 
        error: dangerColor,
        onPrimary: surfaceColor,
        onSecondary: surfaceColor,
        onSurface: neutral900,
        onError: surfaceColor,
      ),
      scaffoldBackgroundColor: neutral50,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: neutral900,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
          borderSide: const BorderSide(color: neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
          borderSide: const BorderSide(color: neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
          borderSide: const BorderSide(color: dangerColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: surfaceColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusGlobal),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
        ),
        shadowColor: neutral900.withValues(alpha: 0.1),
      ),

      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        titleLarge: const TextStyle(color: neutral900, fontWeight: FontWeight.bold),
        titleMedium: const TextStyle(color: neutral900, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: neutral800),
        bodyMedium: const TextStyle(color: neutral800),
        bodySmall: const TextStyle(color: neutral700),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: NoTransitionsBuilder(),
          TargetPlatform.iOS: NoTransitionsBuilder(),
          TargetPlatform.linux: NoTransitionsBuilder(),
          TargetPlatform.macOS: NoTransitionsBuilder(),
          TargetPlatform.windows: NoTransitionsBuilder(),
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dark Theme
  // ---------------------------------------------------------------------------
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: neutral800,
        error: dangerColor,
        onPrimary: neutral100,
        onSecondary: neutral100,
        onSurface: neutral100,
        onError: neutral100,
      ),
      scaffoldBackgroundColor: neutral900,
      appBarTheme: const AppBarTheme(
        backgroundColor: neutral800,
        foregroundColor: neutral100,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: neutral800,
        labelStyle: const TextStyle(color: neutral100),
        hintStyle: TextStyle(color: neutral100.withOpacity(0.5)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
          borderSide: const BorderSide(color: neutral700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
          borderSide: const BorderSide(color: neutral700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
          borderSide: const BorderSide(color: dangerColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: neutral100,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusGlobal),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: neutral800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
        ),
        shadowColor: neutral900.withOpacity(0.3),
      ),
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        titleLarge: const TextStyle(color: neutral100, fontWeight: FontWeight.bold),
        titleMedium: const TextStyle(color: neutral100, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: neutral100),
        bodyMedium: const TextStyle(color: neutral200),
        bodySmall: const TextStyle(color: neutral300),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: NoTransitionsBuilder(),
          TargetPlatform.iOS: NoTransitionsBuilder(),
          TargetPlatform.linux: NoTransitionsBuilder(),
          TargetPlatform.macOS: NoTransitionsBuilder(),
          TargetPlatform.windows: NoTransitionsBuilder(),
        },
      ),
    );
  }
}

/// A clean builder that strips away sliding and fading effects for immediate SPA-like navigation.
class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Return the child directly without any FadeTransition or SlideTransition
    return child;
  }
}
