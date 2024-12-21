import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_assignment/features/authentication/domain/model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  // Constructor that initializes FirebaseAuth instance
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Logs in the user with email and password
  Future<void> login(UserModel user) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
  }

  // Registers a new user with email and password
  Future<void> register(UserModel user) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
  }

  // Stream that listens for authentication state changes
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  // Logs out the current user
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Retrieves the current authenticated user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
