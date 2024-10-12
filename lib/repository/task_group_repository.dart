import '../data/models/task_group.dart';

abstract class ITaskGroupRepository {
  Future<int> addTaskGroup(TaskGroup taskGroup);

  Future<List<TaskGroup>> getTaskGroups();

  Future<TaskGroup?> getTaskGroup(int id);

  Future<int> deleteTaskGroup(int id);

  Future<int> updateTaskGroup(TaskGroup taskGroup);
}
