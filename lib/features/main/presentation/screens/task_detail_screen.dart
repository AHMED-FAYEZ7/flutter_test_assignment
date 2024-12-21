import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_assignment/features/main/presentation/view_models/tasks_view_model.dart';

class DetailScreen extends ConsumerWidget {
  final String itemId;

  const DetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.read(tasksViewModelProvider.notifier);
    final task = viewModel.fetchTaskById(itemId);

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              task.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Details:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              task.details,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Completed:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              task.isCompleted ? 'Yes' : 'No',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
