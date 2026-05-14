import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_state.dart';
import '../features/course/course_detail_screen.dart';
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
import '../features/stats/stats_screen.dart';
import '../features/teacher/teacher_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AppState appState) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: appState,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (!appState.onboardingDone && loc != '/onboarding') {
        return '/onboarding';
      }
      if (appState.onboardingDone && loc == '/onboarding') {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/path',
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: PathScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ranking',
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: RankingScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stats',
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: StatsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) =>
                    const NoTransitionPage<void>(child: ProfileScreen()),
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
        path: '/teacher',
        builder: (context, state) => const TeacherScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
