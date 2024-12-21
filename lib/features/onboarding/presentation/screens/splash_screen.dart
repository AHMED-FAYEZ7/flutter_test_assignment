import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_assignment/core/routing/routes.dart';
import 'package:flutter_test_assignment/features/authentication/data/repository/repository_implementer.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if the user is logged in after a short delay
    _checkLoginStatus(ref, context);
    return const Scaffold(
      body: Center(
        child: Text(
          'Our Splash', // Display splash screen text
          style: TextStyle(
            fontSize: 50, // Large font for splash message
          ),
        ),
      ),
    );
  }
}

// Check the login status of the user and navigate accordingly
Future<void> _checkLoginStatus(WidgetRef ref, BuildContext context) async {
  await Future.delayed(
      const Duration(seconds: 2)); // Delay for splash screen display

  final authRepository = AuthRepository(); // Create auth repository instance
  final user = authRepository
      .authStateChanges()
      .first; // Get the current user's auth state

  user.then((currentUser) {
    // If user is logged in, navigate to main screen
    if (currentUser != null) {
      context.go(Routes.main);
    } else {
      // If user is not logged in, navigate to login screen
      context.go(Routes.login);
    }
  }).catchError((error) {
    // If there's an error, navigate to login screen
    context.go(Routes.login);
  });
}
