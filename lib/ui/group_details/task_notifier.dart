import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/task.dart';
import '../../di.dart';
import '../../repository/task_repository.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  final ITaskRepository taskRepository;

  TaskNotifier(this.taskRepository) : super([]);

  Future<void> loadTasks(int groupId) async {
    final tasks = await taskRepository.getTasks(groupId);
    state = tasks;
  }

  Future<int> addTask(Task task) async {
    final id = await taskRepository.addTask(task);
    state = [...state, task];
    return id;
  }
}

final taskNotifierProvider =
    StateNotifierProvider.family<TaskNotifier, List<Task>, int>((ref, groupId) {
  final taskRepository = getIt.get<ITaskRepository>();
  return TaskNotifier(taskRepository)..loadTasks(groupId);
});
