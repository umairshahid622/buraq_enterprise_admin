
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

    final location = GoRouterState.of(context).uri.toString();
    final mainRoutes = ['/home', '/employees', '/projects', '/profile'];
    final isNestedRoute = !mainRoutes.contains(location);

    final titles = {
      "/home": {
        "heading": "Dashboard",
        "subHeading": "Company-wide overview and analytics",
      },
      "/employees": {
        "heading": "Employees",
        "subHeading": "Manage your team members",
      },
      "/projects": {
        "heading": "Projects",
        "subHeading": "Manage budgets and teams",
      },
      "/profile": {
        "heading": "Profile & Settings",
        "subHeading": "Manage your account preferences",
      },
    };

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading:
            isNestedRoute
                ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    if (GoRouter.of(context).canPop()) {
                      context.pop();
                    }
                  },
                )
                : null,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextHeading(
              text: titles[location]?["heading"] ?? "",
              fontSize: AppConstants.mainHeadingFontSize,
            ),
            SizedBox(height: 10,),
            AppTextBody(
              text: titles[location]?["subHeading"] ?? "",
              color: context.appColors.secondary,
            ),
          ],
        ),
        actions: [ThemeToggleButton()],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.padding),
        child: navigationShell,
      ),
      bottomNavigationBar: SizedBox(
        height: AppConstants.bottomNavigationBarHeight,
        child: BottomNavigationBar(
          elevation: 1,
          backgroundColor: context.appColors.surface,
          selectedItemColor: context.appColors.primary,
          unselectedItemColor: context.appColors.secondary,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationShell.currentIndex,
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'Employees',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
