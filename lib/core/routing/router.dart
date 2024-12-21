import 'package:flutter_test_assignment/core/routing/routes.dart';
import 'package:flutter_test_assignment/features/authentication/presentation/screens/loging_screen.dart';
import 'package:flutter_test_assignment/features/authentication/presentation/screens/register_screen.dart';
import 'package:flutter_test_assignment/features/main/presentation/screens/main_screen.dart';
import 'package:flutter_test_assignment/features/main/presentation/screens/profile_screen.dart';
import 'package:flutter_test_assignment/features/main/presentation/screens/task_detail_screen.dart';
import 'package:flutter_test_assignment/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (context, state) => LoginScreen()),
      GoRoute(
          path: Routes.register,
          builder: (context, state) => RegistrationScreen()),
      GoRoute(
          path: Routes.main, builder: (context, state) => const MainScreen()),
      GoRoute(
        path: Routes.detail,
        builder: (context, state) {
          final id = state.extra as String;
          return DetailScreen(itemId: id);
        },
      ),
      GoRoute(
          path: '/profile', builder: (context, state) => const ProfileScreen()),
    ],
  );
}
