import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension AppColorSchemeContext on BuildContext {
  AppColorScheme get appColors {
    final controller = Get.find<ThemeController>();

    return controller.isDarkMode.value
        ? AppColorScheme.dark
        : AppColorScheme.light;
  }
}
