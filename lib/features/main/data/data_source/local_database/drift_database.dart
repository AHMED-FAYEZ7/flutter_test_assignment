// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

// Define the Tasks table in the database
@DataClassName('TaskEntry')
class Tasks extends Table {
  // Unique identifier for each task
  TextColumn get id => text().customConstraint('NOT NULL PRIMARY KEY')();

  // Title of the task
  TextColumn get title => text()();

  // Detailed description of the task
  TextColumn get details => text()();

  // Task completion status
  BoolColumn get isCompleted => boolean()();

  // User ID associated with the task
  TextColumn get userId => text()(); // Added userId field
}

// Database class that manages access to the Tasks table
@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Fetch tasks for a specific user
  Future<List<TaskEntry>> getTasksForUser(String userId) {
    return (select(tasks)..where((tbl) => tbl.userId.equals(userId))).get();
  }

  // Insert a new task or update it if it already exists
  Future<void> insertOrUpdateTask(TasksCompanion task) =>
      into(tasks).insertOnConflictUpdate(task);

  // Delete a task by its ID
  Future<void> deleteTask(String id) =>
      (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();
}

// Open a connection to the SQLite database stored in the app's document directory
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
