import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_assignment/core/routing/routes.dart';
import 'package:flutter_test_assignment/features/authentication/presentation/view_models/authentication_view_model.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authenticationViewModelProvider.notifier);

    final currentUser = authViewModel.getCurrentUser();

    if (currentUser == null) {
      return const Center(child: Text('User is not logged in.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Email: ${currentUser.email ?? "Not available"}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await authViewModel.logout();
                  Phoenix.rebirth(context);

                  context.pushReplacement(Routes.login);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
