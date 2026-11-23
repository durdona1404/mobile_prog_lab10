import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class DesignCredit {
  static const String name = 'Name of the Figma file';
  static const String author = 'Author name';
  static const String link = 'https://www.figma.com/community/file/...';
  static const String licence = 'CC BY 4.0';
}

class AppTheme {
  static const String? fontFamily = null;
  static const double radius = 16;
  static const double barHeight = 8;

  static const Color primary = Color(0xFF0F8B6D);
  static const Color background = Color(0xFFF6F7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1B1F24);
  static const Color muted = Color(0xFF6B7280);
  static const Color error = Color(0xFFB3261E);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      onPrimary: surface,
      surface: surface,
      onSurface: text,
      onSurfaceVariant: muted,
      error: error,
    );

    const textTheme = TextTheme(
      headlineMedium:
          TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: text),
      titleLarge:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: text),
      titleMedium:
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: text),
      bodyLarge:
          TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: text),
      bodyMedium:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: muted),
      labelLarge:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: text),
    );

    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shape,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: shape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: shape,
          side: const BorderSide(color: primary),
          textStyle: textTheme.labelLarge,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelLarge),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        side: BorderSide.none,
        shape: shape,
        labelStyle: textTheme.bodyMedium,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primary),
    );
  }
}