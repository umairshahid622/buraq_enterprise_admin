import 'package:buraq_enterprise_admin/core/config/app_router.dart';
import 'package:buraq_enterprise_admin/core/config/colors/app_theme.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/firebase_options.dart';
import 'package:buraq_enterprise_admin/core/bindings/initial_bindings.dart';

import 'package:buraq_enterprise_admin/screens/controllers/common/theme_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  InitialBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "Buraq Enterprise",
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        scaffoldMessengerKey: AppConstants.scaffoldMessengerKey,
        routerConfig: appRouter,
      );
    });
  }
}
