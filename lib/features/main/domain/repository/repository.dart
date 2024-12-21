import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test_assignment/features/main/data/data_source/local_database/drift_database.dart';
import 'package:flutter_test_assignment/features/main/data/repository/repository_implementer.dart';
import 'package:riverpod/riverpod.dart';

// Riverpod provider to create and provide an instance of TasksRepository
final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final firestore = FirebaseFirestore.instance; // Firestore instance
  final database = AppDatabase(); // Local Drift database instance

  // Return an instance of TasksRepositoryImpl using Firestore and local database
  return TasksRepositoryImpl(firestore, database);
});
