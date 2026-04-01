
import 'package:buraq_enterprise_admin/utils/widgets/buttons/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final showBack = location != '/auth/login';

    return Scaffold(
      appBar: AppBar(
        leading:
            showBack
                ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.pop(),
                )
                : null,

        actions: [ThemeToggleButton()],
      ),
      body: SafeArea(child: child),
    );
  }
}
