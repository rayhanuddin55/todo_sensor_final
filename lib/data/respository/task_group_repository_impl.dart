import '../../repository/task_group_repository.dart';
import '../database_helper.dart';
import '../models/task_group.dart';

class TaskGroupRepositoryImpl implements ITaskGroupRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<int> addTaskGroup(TaskGroup taskGroup) async {
    final db = await _dbHelper.database;
    return await db.insert('task_groups', taskGroup.toMap());
  }

  @override
  Future<List<TaskGroup>> getTaskGroups() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('task_groups');
    return List.generate(maps.length, (i) {
      return TaskGroup.fromMap(maps[i]);
    });
  }

  @override
  Future<int> deleteTaskGroup(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('task_groups', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTaskGroup(TaskGroup taskGroup) async {
    final db = await _dbHelper.database;
    return await db.update('task_groups', taskGroup.toMap(),
        where: 'id = ?', whereArgs: [taskGroup.id]);
  }

  @override
  Future<TaskGroup?> getTaskGroup(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'task_groups',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskGroup.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
