import '../data/models/task.dart';

abstract class ITaskRepository {
  Future<int> addTask(Task task);

  Future<List<Task>> getTasks(int groupId);

  Future<Task?> getTask(int id);

  Future<List<Task>> getAllTasks();

  Future<int> deleteTask(int id);

  Future<int> updateTask(Task task);

  Future<int> toggleTaskCompletion(int taskId, bool isComplete);
}
