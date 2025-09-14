import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Color Tokens (Dark-first)
  static const Color background = Color(0xFF0E1116);
  static const Color surface = Color(0xFF12161F);
  static const Color surfaceAlt = Color(0xFF161B26);
  static const Color textPrimary = Color(0xFFE6E9EE);
  static const Color textSecondary = Color(0xFFAEB7C3);
  static const Color divider = Color(0xFF2A3240);
  static const Color accentPrimary = Color(0xFF5ED0B5); // Warm teal
  static const Color accentMuted = Color(0xFF3FA18E);
  static const Color success = Color(0xFF86EFAC);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF7DD3FC);
  static const Color error = Color(0xFFF87171);

  // Typography
  static const String fontFamily = 'Montserrat';
  
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 1.21, // 34/28
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    height: 1.27, // 28/22
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 1.33, // 24/18
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.375, // 22/16
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 1.38, // 18/13
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  // Tabular numerals for time display (prevents layout jitter)
  static const TextStyle timeDisplay = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 1.21, // 34/28
    fontWeight: FontWeight.w600,
    color: textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle timeDisplayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    height: 1.17, // 42/36
    fontWeight: FontWeight.w600,
    color: textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Spacing Scale
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  // Border Radius
  static const double radiusCard = 16;
  static const double radiusButton = 12;
  static const double radiusInput = 8;

  // Shadows (ultra-soft for night)
  static const List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 12,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 20,
      offset: Offset(0, 5),
    ),
  ];

  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x06000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accentPrimary,
        secondary: accentMuted,
        surface: surface,
        background: background,
        error: error,
        onPrimary: background,
        onSecondary: background,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: background,
      ),
      textTheme: const TextTheme(
        headlineLarge: h1,
        headlineMedium: h2,
        titleLarge: title,
        bodyLarge: body,
        bodyMedium: body,
        bodySmall: caption,
      ),
      fontFamily: fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: title,
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPrimary,
          foregroundColor: background,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          minimumSize: const Size(0, 44), // Min 44dp height
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentPrimary,
          side: const BorderSide(color: accentPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPrimary,
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: accentPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        hintStyle: caption.copyWith(color: textSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusCard),
          ),
        ),
      ),
    );
}
