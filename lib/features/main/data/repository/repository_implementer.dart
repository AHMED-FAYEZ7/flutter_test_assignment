import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test_assignment/features/main/data/data_source/local_database/drift_database.dart';
import 'package:flutter_test_assignment/features/main/domain/model/task_mode.dart';

// Abstract repository interface for task management
abstract class TasksRepository {
  Future<void> addTask(TaskModel task, String userId);
  Future<void> deleteTask(String id, String userId);
  Stream<List<TaskModel>> getTasksStream(String userId);
  Future<void> syncLocalWithFirestore(String userId);
}

// Implementation of the TasksRepository using Firestore and Drift (local database)
class TasksRepositoryImpl implements TasksRepository {
  final FirebaseFirestore _firestore;
  final AppDatabase _database;

  TasksRepositoryImpl(this._firestore, this._database);

  // Add task to Firestore and local database (Drift)
  @override
  Future<void> addTask(TaskModel task, String userId) async {
    final docRef = _firestore.collection('tasks').doc(task.id);
    await docRef.set({
      ...task.toJson(),
      'userId': userId, // Add userId to Firestore document
    });

    // Add task to local database (Drift)
    await _database.insertOrUpdateTask(
      TasksCompanion(
        id: Value(task.id),
        title: Value(task.title),
        details: Value(task.details),
        isCompleted: Value(task.isCompleted),
        userId: Value(userId),
      ),
    );
  }

  // Delete task from Firestore and local database (Drift)
  @override
  Future<void> deleteTask(String id, String userId) async {
    await _firestore
        .collection('tasks')
        .doc(id)
        .delete(); // Delete from Firestore
    await _database.deleteTask(id); // Delete from local database
  }

  // Stream of tasks for a specific user from Firestore
  @override
  Stream<List<TaskModel>> getTasksStream(String userId) {
    final firestoreStream = _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TaskModel.fromJson(
            data, doc.id, userId); // Convert Firestore data to TaskModel
      }).toList();
    });

    return firestoreStream; // Return stream of tasks
  }

  // Sync tasks from Firestore to the local database (Drift)
  @override
  Future<void> syncLocalWithFirestore(String userId) async {
    final firestoreTasks = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get(); // Fetch tasks from Firestore

    // Add each task to local database (Drift)
    for (var doc in firestoreTasks.docs) {
      final task = TaskModel.fromJson(doc.data(), doc.id, userId);
      await _database.insertOrUpdateTask(
        TasksCompanion(
          id: Value(task.id),
          title: Value(task.title),
          details: Value(task.details),
          isCompleted: Value(task.isCompleted),
          userId: Value(userId),
        ),
      );
    }
  }
}
