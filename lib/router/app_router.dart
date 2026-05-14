import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_state.dart';
import '../core/models/user_role.dart';
import '../core/routes/app_routes.dart';
import '../core/services/firebase_bootstrap.dart';
import '../core/services/group_repository.dart';
import '../features/about/about_screen.dart';
import '../features/auth/email_auth_screen.dart';
import '../features/course/course_detail_screen.dart';
import '../features/groups/group_detail_screen.dart';
import '../features/groups/group_chat_screen.dart';
import '../features/groups/join_group_screen.dart';
import '../features/groups/teacher_groups_screen.dart';
import '../features/home/home_screen.dart';
import '../features/lesson/exercise_screen.dart';
import '../features/lesson/lesson_results_screen.dart';
import '../features/lesson/lesson_theory_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/path/path_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/ranking/ranking_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/shell/teacher_shell.dart';
import '../features/stats/stats_screen.dart';
import '../features/teacher/teacher_account_screen.dart';
import '../features/teacher/teacher_dashboard_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

String? _redirect(AppState appState, GoRouterState state) {
  final loc = state.matchedLocation;

  if (loc == AppRoutes.about) {
    return null;
  }

  if (!FirebaseBootstrap.firebaseAppReady) {
    if (loc == AppRoutes.auth || loc == AppRoutes.about) return null;
    return AppRoutes.auth;
  }

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    if (loc == AppRoutes.auth || loc.startsWith('/course') || loc == AppRoutes.about) return null;
    return AppRoutes.auth;
  }

  if (loc == AppRoutes.auth) {
    if (!appState.onboardingDone) return AppRoutes.onboarding;
    return AppRoutes.homeForRole(appState.userRole == UserRole.teacher);
  }

  if (!appState.onboardingDone && loc != AppRoutes.onboarding && loc != AppRoutes.about) {
    return AppRoutes.onboarding;
  }

  if (appState.onboardingDone && loc == AppRoutes.onboarding) {
    return AppRoutes.homeForRole(appState.userRole == UserRole.teacher);
  }

  final teacher = appState.userRole == UserRole.teacher;
  const legacy = {'/home', '/path', '/ranking', '/stats', '/profile'};
  if (teacher) {
    if (loc.startsWith('/s/')) return AppRoutes.tGroups;
    if (legacy.contains(loc)) return AppRoutes.tGroups;
  } else {
    if (loc.startsWith('/t/')) return AppRoutes.sHome;
    if (loc == '/home') return AppRoutes.sHome;
    if (loc == '/path') return AppRoutes.sPath;
    if (loc == '/ranking') return AppRoutes.sRanking;
    if (loc == '/stats') return AppRoutes.sStats;
    if (loc == '/profile') return AppRoutes.sProfile;
  }
  return null;
}

GoRouter createAppRouter(AppState appState) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.auth,
    refreshListenable: appState,
    redirect: (context, state) => _redirect(appState, state),
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const EmailAuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return StudentShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sHome,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sPath,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: PathScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sRanking,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: RankingScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sStats,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: StatsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sProfile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return TeacherShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tDashboard,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: TeacherDashboardScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tGroups,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: TeacherGroupsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tStats,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: StatsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tAccount,
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: TeacherAccountScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/course/:courseId',
        builder: (context, state) =>
            CourseDetailScreen(courseId: state.pathParameters['courseId']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/course/:courseId/lesson/:lessonId',
        builder: (context, state) => LessonTheoryScreen(
          courseId: state.pathParameters['courseId']!,
          lessonId: state.pathParameters['lessonId']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/course/:courseId/lesson/:lessonId/exercise/:exIndex',
        builder: (context, state) => ExerciseScreen(
          courseId: state.pathParameters['courseId']!,
          lessonId: state.pathParameters['lessonId']!,
          exerciseIndex: int.parse(state.pathParameters['exIndex']!),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/course/:courseId/lesson/:lessonId/results',
        builder: (context, state) => LessonResultsScreen(
          courseId: state.pathParameters['courseId']!,
          lessonId: state.pathParameters['lessonId']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/group-chat/:groupId',
        builder: (context, state) => GroupChatScreen(
          groupId: state.pathParameters['groupId']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/teacher/group/:groupId',
        builder: (context, state) => GroupDetailScreen(
          groupId: state.pathParameters['groupId']!,
          initial: state.extra as GroupInfo?,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/join-group',
        builder: (context, state) => const JoinGroupScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
