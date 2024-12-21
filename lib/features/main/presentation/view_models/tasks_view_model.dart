import 'package:flutter_test_assignment/features/authentication/presentation/view_models/authentication_view_model.dart';
import 'package:flutter_test_assignment/features/main/data/repository/repository_implementer.dart';
import 'package:flutter_test_assignment/features/main/domain/repository/repository.dart';
import 'package:flutter_test_assignment/features/main/domain/model/task_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_view_model.g.dart';

// Riverpod ViewModel for managing tasks and syncing with repository
@riverpod
class TasksViewModel extends _$TasksViewModel {
  late final TasksRepository _repository;
  late final String _userId;

  @override
  List<TaskModel> build() {
    // Get current user from authentication view model
    final user =
        ref.watch(authenticationViewModelProvider.notifier).getCurrentUser();
    _userId = user != null ? user.uid : ''; // Set userId
    _repository = ref.read(tasksRepositoryProvider); // Get tasks repository
    _syncTasks(); // Sync tasks from repository
    return []; // Return empty list initially
  }

  // Sync tasks from the repository and update the state
  void _syncTasks() {
    _repository.getTasksStream(_userId).listen((tasks) {
      state = tasks; // Update state with new tasks
    });
  }

  // Add task to the repository and sync with Firestore and local database
  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task, _userId);
    print(_userId.toString()); // Print userId for debugging
  }

  // Delete task from the repository and sync with Firestore and local database
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id, _userId);
  }

  // Fetch a task by its ID from the current state
  TaskModel fetchTaskById(String id) {
    return state.firstWhere(
      (task) => task.id == id, // Find task by ID
      orElse: () => TaskModel(
        id: id,
        title: 'Unknown Task', // Default title if not found
        details: 'No details available', // Default details if not found
        isCompleted: false,
        userId: _userId,
      ),
    );
  }
}
