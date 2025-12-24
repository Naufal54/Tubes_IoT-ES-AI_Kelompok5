import 'package:eldercare/features/emergency/emergency_page.dart';
import 'package:eldercare/features/home/home_page.dart';
import 'package:eldercare/features/profile/edit_profile_page.dart';
import 'package:eldercare/features/profile/profile_page.dart';
import 'package:eldercare/features/profile/settings_page.dart';
import 'package:eldercare/main_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/emergency',
              builder: (context, state) => const EmergencyPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'edit-profile',
                  builder: (context, state) => const EditProfilePage(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
