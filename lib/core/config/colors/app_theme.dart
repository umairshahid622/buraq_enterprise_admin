import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  
  // Use our custom color scheme
  static const AppColorScheme _lightColors = AppColorScheme.light;
  static const AppColorScheme _darkColors = AppColorScheme.dark;

  // Create Material 3 ColorScheme from our custom scheme (for compatibility)
  static ColorScheme _createMaterialColorScheme(AppColorScheme appColors) {
    return ColorScheme(
      brightness: appColors.brightness,
      primary: appColors.primary,
      onPrimary:
          appColors.brightness == Brightness.light
              ? Colors.white
              : Colors.black,

      secondary: appColors.secondary,
      onSecondary: Colors.white,

      error: appColors.error,
      onError: appColors.onError,

      surface: appColors.surface,
      onSurface: appColors.text,

      inversePrimary: appColors.primaryVariant,
    );
  }

  static final ColorScheme _lightScheme = _createMaterialColorScheme(
    _lightColors,
  );
  static final ColorScheme _darkScheme = _createMaterialColorScheme(
    _darkColors,
  );

  // -------------------- LIGHT THEME --------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _lightScheme,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightScheme.surface,

    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: _lightScheme.surface,
      foregroundColor: _lightScheme.onSurface,
      surfaceTintColor: _lightScheme.surfaceTint,
    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(style: BorderStyle.none),
      overlayColor: WidgetStatePropertyAll(
        _lightScheme.primary.withValues(alpha: .08),
      ),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightScheme.primary;
        }
        return _lightScheme.outline;
      }),
      checkColor: WidgetStatePropertyAll(_lightScheme.onPrimary),
    ),

    cardTheme: CardThemeData(
      color: _lightScheme.surface, // base background for cards
      surfaceTintColor: _lightScheme.surfaceTint,
      elevation: 0, // clean flat look (modern)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: _lightScheme.outline.withValues(alpha: .2), // subtle border
        ),
      ),
      margin: const EdgeInsets.all(0), // remove default padding
    ),
  );

  // -------------------- DARK THEME --------------------
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _darkScheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkScheme.surface,

    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: _darkScheme.surface,
      foregroundColor: _darkScheme.onSurface,
      surfaceTintColor: _darkScheme.surfaceTint,
    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(style: BorderStyle.none),
      overlayColor: WidgetStatePropertyAll(
        _darkScheme.primary.withValues(alpha: .12),
      ),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkScheme.primary;
        }
        return _darkScheme.outline;
      }),
      checkColor: WidgetStatePropertyAll(_darkScheme.onPrimary),
    ),

    cardTheme: CardThemeData(
      color: _darkScheme.surfaceContainerLow, // softer than full surface
      surfaceTintColor: _darkScheme.surfaceTint,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(color: _darkScheme.outline.withValues(alpha: .1)),
      ),
      margin: const EdgeInsets.all(0),
    ),
  );
}