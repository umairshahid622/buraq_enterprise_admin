// core/config/app_router.dart

import 'package:buraq_enterprise_admin/core/config/app_session.dart';
import 'package:buraq_enterprise_admin/core/config/router_refresh_stream.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/layouts/auth_layout.dart';
import 'package:buraq_enterprise_admin/layouts/main_layout.dart';
import 'package:buraq_enterprise_admin/screens/auth/login_screen.dart';
import 'package:buraq_enterprise_admin/screens/widgets/employees/add_employee_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/employees/employee_manage_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/employees/employee_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/home/home_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/profile/change_name_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/profile/profile_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/projects/add_project_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/projects/project_members_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/projects/project_screen_widget.dart';
import 'package:buraq_enterprise_admin/screens/widgets/splash/splash_screen_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final RouterRefreshStream _authStatus = RouterRefreshStream();

final appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: _authStatus,
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreenWidget()),
    ShellRoute(
      navigatorKey: AppConstants.rootNavigatorKey,
      builder: (context, state, child) => AuthLayout(child: child),
      routes: [
        GoRoute(
          path: '/auth/login',
          pageBuilder: (_, _) => NoTransitionPage(
            child: Builder(
              builder: (context) {
                return const LoginScreen();
              },
            ),
          ),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: HomeScreenWidget()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/employees',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: EmployeeScreenWidget()),
              routes: [
                GoRoute(
                  path: 'add-employee',
                  pageBuilder: (context, state) =>
                      NoTransitionPage(child: AddEmployeeScreenWidget()),
                ),
                GoRoute(
                  path: 'manage/:employeeId',
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: EmployeeManageScreenWidget(
                      employeeId: state.pathParameters['employeeId'] ?? '',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projects',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: ProjectScreenWidget()),
              routes: [
                GoRoute(
                  path: 'add-project',
                  pageBuilder: (context, state) =>
                      NoTransitionPage(child: AddProjectScreenWidget()),
                ),
                GoRoute(
                  path: 'manage/:projectId',
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: ProjectMembersScreenWidget(
                      projectId: state.pathParameters['projectId'] ?? '',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: ProfileScreenWidget()),
              routes: [
                GoRoute(
                  path: 'change-name',
                  pageBuilder: (context, state) =>
                      NoTransitionPage(child: ChangeNameScreenWidget()),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final bool isSplash = state.matchedLocation == '/splash';
    final user = FirebaseAuth.instance.currentUser;

    // 1. If we haven't finished the Splash logic, stay on Splash
    if (!appSession.isReady) {
      return '/splash';
    }

    // 2. Once ready, check Auth
    if (user == null) {
      return state.matchedLocation.startsWith('/auth') ? null : '/auth/login';
    }

    // 3. If logged in and on Splash/Login, go Home
    if (isSplash || state.matchedLocation.startsWith('/auth')) {
      return '/home';
    }

    return null;
  },
);
