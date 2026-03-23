import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized application theme adapting styles from styles.scss
class AppTheme {
  // Centro Primary Colors (Respetado como principal pero para acentos sutiles)
  static const Color primaryColor = Color(0xFFA3892F); // Un dorado un poco más refinado/suave
  static const Color primaryDark = Color(0xFF7A6822); 
  static const Color accentGold = Color(0xFFA3892F);
  static const Color vibrantGold = Color(0xFFB39716);

  // Secondary Color (Referencia: Gris Carbón casi Negro en lugar de Teal para mayor elegancia)
  static const Color secondaryColor = Color(0xFF1E1E1E);

  // Alert Colors
  static const Color successColor = Color(0xFF43B581);
  static const Color warningColor = Color(0xFFF4D35E);
  static const Color dangerColor = Color(0xFFDA3E3E);

  // Neutral Colors
  static const Color neutral900 = Color(0xFF141414);
  static const Color neutral800 = Color(0xFF373737);
  static const Color neutral700 = Color(0xFF5B5B5B);
  static const Color neutral600 = Color(0xFF727272);
  static const Color neutral500 = Color(0xFF8A8A8A);
  static const Color neutral400 = Color(0xFFA1A1A1);
  static const Color neutral300 = Color(0xFFB9B9B9);
  static const Color neutral200 = Color(0xFFD0D0D0);
  static const Color neutral100 = Color(0xFFE8E8E8);
  static const Color neutral50 = Color(0xFFF6F6F6);

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
        surface: Color(0xFFFDFDFD), // Casi blanco, pero no total
        error: dangerColor,
        onPrimary: Color(0xFFFDFDFD),
        onSecondary: Color(0xFFFDFDFD),
        onSurface: neutral900,
        onError: Color(0xFFFDFDFD),
      ),
      scaffoldBackgroundColor: neutral50,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // AppBar limpia y neutral
        foregroundColor: neutral900,         // Texto oscuro
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFDFDFD),
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
          foregroundColor: const Color(0xFFFDFDFD),
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
        color: const Color(0xFFFDFDFD),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusGlobal),
        ),
        shadowColor: neutral900.withValues(alpha: 0.1),
      ),
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        bodyMedium: const TextStyle(color: neutral800),
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
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: neutral900,
      appBarTheme: const AppBarTheme(
        backgroundColor: neutral800,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: neutral800,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
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
          foregroundColor: Colors.white,
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
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        titleLarge: const TextStyle(color: Colors.white),
        titleMedium: const TextStyle(color: Colors.white),
        bodyLarge: const TextStyle(color: Colors.white),
        bodyMedium: const TextStyle(color: neutral200),
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
