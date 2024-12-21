import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_assignment/features/authentication/data/repository/repository_implementer.dart';
import 'package:flutter_test_assignment/features/authentication/domain/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_view_model.g.dart';

@riverpod
class AuthenticationViewModel extends _$AuthenticationViewModel {
  final AuthRepository _authRepository;

  // Constructor for AuthenticationViewModel, initializes repository
  AuthenticationViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  @override
  AuthenticationState build() => AuthenticationState();

  // Logs in the user with email and password
  Future<void> login(UserModel user) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.login(user); // Attempt login
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseErrorToMessage(e),
      );
    } catch (e) {
      // Handle unexpected errors
      state = state.copyWith(
        isLoading: false,
        errorMessage: "An unexpected error occurred. Please try again.",
      );
    }
  }

  // Registers a new user
  Future<void> register(UserModel user) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.register(user); // Attempt registration
      state = state.copyWith(isLoading: false, isSuccess: true);
      print('User registered successfully');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseErrorToMessage(e),
      );
    } catch (e) {
      // Handle unexpected errors
      state = state.copyWith(
        isLoading: false,
        errorMessage: "An unexpected error occurred. Please try again.",
      );
    }
  }

  // Logs out the current user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.logout(); // Attempt logout
      state = AuthenticationState(); // Reset state after logout
    } catch (e) {
      // Handle logout errors
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to log out. Please try again.",
      );
    }
  }

  // Retrieves the current authenticated user
  User? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }
}

class AuthenticationState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  AuthenticationState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  // Returns a copy of the state with updated values
  AuthenticationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Maps Firebase authentication error to a readable message
String _mapFirebaseErrorToMessage(FirebaseAuthException e) {
  final errorMessage =
      e.message?.split('] ').last ?? "An unknown error occurred.";
  return errorMessage;
}
