import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_scheduler/screens/auth/login_screen.dart';
import 'package:my_scheduler/screens/auth/register_screen.dart';
import 'package:my_scheduler/screens/auth/profile_setup_screen.dart';
import 'package:my_scheduler/screens/home/home_screen.dart';
import 'package:my_scheduler/utils/constants.dart';
import 'package:my_scheduler/utils/go_router_refresh_stream.dart';
import 'package:my_scheduler/screens/schedule/schedule.dart';
import 'package:my_scheduler/screens/examination/examination.dart';
import 'package:my_scheduler/screens/attendance/attendance.dart';
import 'package:my_scheduler/screens/reports/reports.dart';
import 'package:my_scheduler/screens/reports/detailed_report_screen.dart';
import 'package:my_scheduler/screens/settings/settings.dart';
import 'package:my_scheduler/screens/teams/teams.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(supabase.auth.onAuthStateChange),
    redirect: (context, state) async {
      final session = supabase.auth.currentSession;
      final isLoggingIn =
          state.uri.path == '/login' || state.uri.path == '/register';

      if (session == null) {
        if (!isLoggingIn) return '/login';
        return null;
      }

      // If user is logged in, check profile
      // We perform a direct check here. Optimally this should be cached.
      try {
        final user = session.user;
        final profileResponse = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle(); // maybeSingle returns null if not found

        final hasProfile = profileResponse != null;
        final hasSection = hasProfile && profileResponse['section'] != null;
        final hasSubsection =
            hasProfile && profileResponse['subsection'] != null;

        if (!hasSection || !hasSubsection) {
          if (state.uri.path != '/profile_setup') return '/profile_setup';
          return null;
        }

        if (isLoggingIn ||
            state.uri.path == '/splash' ||
            state.uri.path == '/profile_setup') {
          return '/home';
        }
      } catch (e) {
        // If error, maybe stay on splash or go to logic?
        // For safety, let's assume if we can't fetch profile, we might be offline or erroring.
        // But if we have session, we should probably allow access or show error.
        // Let's safe fail to profile setup if we are stuck.
        debugPrint('Error fetching profile in redirect: $e');
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/profile_setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/schedule',
        builder: (context, state) => const ScheduleScreen(),
      ),
      GoRoute(
        path: '/examination',
        builder: (context, state) => const ExaminationScreen(),
      ),
      GoRoute(
        path: '/attendance',
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/reports/detail',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return DetailedReportScreen(
            semesterId: data['semesterId'],
            category: data['category'],
            categoryKey: data['categoryKey'],
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/teams',
        builder: (context, state) => const TeamsScreen(),
      ),
    ],
  );
});
