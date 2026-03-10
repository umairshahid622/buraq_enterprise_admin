import 'package:buraq_enterprise_admin/screens/controllers/common/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class AppColorScheme {
  final Color colorButtonText;

  // Primary colors
  final Color primary;
  final Color primaryVariant;
  final Color colorGreen;
  final Color colorBlue;

  // Secondary colors
  final Color secondary;

  // Error colors
  final Color error;
  final Color onError;

  // Background & Surface colors
  final Color background;
  final Color surface;
  final Color text;

  // Border
  final Color outline;

  // Brightness
  final Brightness brightness;

  const AppColorScheme({
    required this.primary,
    required this.primaryVariant,
    required this.colorGreen,
    required this.colorBlue,
    required this.secondary,
    required this.error,
    required this.onError,
    required this.background,
    required this.surface,
    required this.text,
    required this.outline,
    required this.brightness,
    required this.colorButtonText,
  });

  /// Light scheme
  static const AppColorScheme light = AppColorScheme(
    primary: AppColors.primary,
    primaryVariant: AppColors.primaryDark,
    secondary: AppColors.secondary,
    error: AppColors.error,
    onError: AppColors.onErrorLight,
    background: AppColors.lightBg,
    surface: AppColors.lightSurface,
    text: AppColors.lightOn,
    outline: AppColors.lightOutline,
    colorGreen: AppColors.colorGreenLight,
    colorBlue: AppColors.colorBlueLight,
    colorButtonText: AppColors.colorButtonText,
    brightness: Brightness.light,
  );

  /// Dark scheme
  static const AppColorScheme dark = AppColorScheme(
    primary: AppColors.primaryDark,
    primaryVariant: AppColors.primary,
    secondary: AppColors.secondaryDark,
    error: AppColors.error,
    onError: AppColors.onErrorDark,
    background: AppColors.darkBg,
    surface: AppColors.darkSurface,
    text: AppColors.darkOn,
    outline: AppColors.darkOutline,
    colorGreen: AppColors.colorGreenDark,
    colorBlue: AppColors.colorBlueDark,
    colorButtonText: AppColors.colorButtonText,
    brightness: Brightness.dark,
  );

  /// GetX-based scheme resolver
  static AppColorScheme of() {
    final controller = Get.find<ThemeController>();

    return controller.isDarkMode.value ? dark : light;
  }
}




// import 'package:flutter/material.dart';

// class AppColorScheme {
//   final Color colorButtonText;

//   // Primary colors
//   final Color primary;
//   final Color primaryVariant;
//   final Color colorGreen;
//   final Color colorBlue;

//   // Secondary colors
//   final Color secondary;

//   // Error colors
//   final Color error;
//   final Color onError;

//   // Background & Surface colors
//   final Color background;
//   final Color surface;
//   final Color text; // Text color on background/surface

//   // Border/Outline colors
//   final Color outline;

//   // Brightness
//   final Brightness brightness;

//   const AppColorScheme({
//     required this.primary,
//     required this.primaryVariant,
//     required this.colorGreen,
//     required this.colorBlue,
//     required this.secondary,
//     required this.error,
//     required this.onError,
//     required this.background,
//     required this.surface,
//     required this.text,
//     required this.outline,
//     required this.brightness,
//     required this.colorButtonText
//   });

//   /// Light theme color scheme
//   static const AppColorScheme light = AppColorScheme(
//     primary: AppColors.primary,
//     primaryVariant: AppColors.primaryDark,
//     secondary: AppColors.secondary,
//     error: AppColors.error,
//     onError: AppColors.onErrorLight,
//     background: AppColors.lightBg,
//     surface: AppColors.lightSurface,
//     text: AppColors.lightOn,
//     outline: AppColors.lightOutline,
//     colorGreen: AppColors.colorGreenLight,
//     colorBlue: AppColors.colorBlueLight,
//     colorButtonText: AppColors.colorButtonText,
//     brightness: Brightness.light,
//   );

//   /// Dark theme color scheme
//   static const AppColorScheme dark = AppColorScheme(
//     primary: AppColors.primaryDark, // Slightly lighter in dark mode
//     primaryVariant: AppColors.primary,
//     secondary: AppColors.secondaryDark,
//     error: AppColors.error,
//     onError: AppColors.onErrorDark,
//     background: AppColors.darkBg,
//     surface: AppColors.darkSurface,
//     text: AppColors.darkOn,
//     outline: AppColors.darkOutline,
//     colorGreen: AppColors.colorGreenDark,
//     colorBlue: AppColors.colorBlueDark,
//     colorButtonText: AppColors.colorButtonText,
//     brightness: Brightness.dark,
//   );

//   /// Helper method to get the current color scheme from context
//   /// Uses ThemeCubit to detect theme mode, with fallback to system brightness
//   static AppColorScheme of(BuildContext context) {
//     try {
//       final themeCubit = context.watch<ThemeCubit>();
//       final mode = themeCubit.state;

//       if (mode == ThemeMode.dark) {
//         return dark;
//       } else if (mode == ThemeMode.light) {
//         return light;
//       } else {
//         // ThemeMode.system - fallback to system brightness
//         final brightness = Theme.of(context).brightness;
//         return brightness == Brightness.dark ? dark : light;
//       }
//     } catch (e) {
//       // Fallback if ThemeCubit is not available
//       final brightness = Theme.of(context).brightness;
//       return brightness == Brightness.dark ? dark : light;
//     }
//   }
// }

// /// Extension to easily access AppColorScheme from Theme
// /// Note: This extension uses brightness as fallback.
// /// For ThemeCubit-based detection, use context.appColors instead.
// extension AppColorSchemeExtension on ThemeData {
//   AppColorScheme get appColorScheme {
//     return brightness == Brightness.dark
//         ? AppColorScheme.dark
//         : AppColorScheme.light;
//   }
// }

// /// Extension to easily access AppColorScheme from BuildContext
// /// Uses ThemeCubit to detect theme mode, with fallback to system brightness
// extension AppColorSchemeContextExtension on BuildContext {
//   AppColorScheme get appColors {
//     try {
//       final themeCubit = watch<ThemeCubit>();
//       final mode = themeCubit.state;

//       if (mode == ThemeMode.dark) {
//         return AppColorScheme.dark;
//       } else if (mode == ThemeMode.light) {
//         return AppColorScheme.light;
//       } else {
//         // ThemeMode.system - fallback to system brightness
//         final brightness = Theme.of(this).brightness;
//         return brightness == Brightness.dark
//             ? AppColorScheme.dark
//             : AppColorScheme.light;
//       }
//     } catch (e) {
//       // Fallback if ThemeCubit is not available
//       final brightness = Theme.of(this).brightness;
//       return brightness == Brightness.dark
//           ? AppColorScheme.dark
//           : AppColorScheme.light;
//     }
//   }
// }
