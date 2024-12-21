import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_assignment/core/routing/routes.dart';
import 'package:flutter_test_assignment/features/authentication/presentation/view_models/authentication_view_model.dart';
import 'package:flutter_test_assignment/features/main/domain/model/task_mode.dart';
import 'package:flutter_test_assignment/features/main/presentation/view_models/tasks_view_model.dart';
import 'package:uuid/uuid.dart';

import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksViewModelProvider);
    final viewModel = ref.read(tasksViewModelProvider.notifier);
    final authViewModel = ref.watch(authenticationViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.push(Routes.profile);
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks available'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.details),
                  onTap: () {
                    context.push(Routes.detail, extra: task.id);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => viewModel.deleteTask(task.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showAddTaskDialog(context, viewModel, authViewModel);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TasksViewModel viewModel,
      AuthenticationViewModel authViewModel) {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    final uuid = Uuid();

    final currentUser = authViewModel.getCurrentUser();

    if (currentUser == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'Task Details'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                final newTask = TaskModel(
                  id: uuid.v4(),
                  title: titleController.text.trim(),
                  details: detailsController.text.trim(),
                  isCompleted: false,
                  userId: currentUser.uid,
                );
                await viewModel.addTask(newTask);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
