import 'package:buraq_enterprise_admin/screens/controllers/common/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      return IconButton(
        tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            key: ValueKey(isDark),
          ),
        ),
        onPressed: controller.toggleTheme,
      );
    });
  }
}
