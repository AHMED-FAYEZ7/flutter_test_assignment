import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_assignment/core/routing/routes.dart';
import 'package:flutter_test_assignment/features/authentication/domain/model/user_model.dart';
import 'package:flutter_test_assignment/features/authentication/presentation/view_models/authentication_view_model.dart';
import 'package:go_router/go_router.dart';

class RegistrationScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(authenticationViewModelProvider);
    ref.listen<AuthenticationState>(authenticationViewModelProvider,
        (previous, next) {
      if (next.isSuccess) {
        context.pushReplacement(Routes.main);
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    } else if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                if (registrationState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () async {
                      final user = UserModel(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        confirmPassword: _confirmPasswordController.text.trim(),
                      );
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(authenticationViewModelProvider.notifier)
                            .register(user);
                      }
                    },
                    child: const Text('Register'),
                  ),
                TextButton(
                  onPressed: () => context.pushReplacement(Routes.login),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
