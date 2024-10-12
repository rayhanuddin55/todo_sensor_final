import '../../repository/task_repository.dart';
import '../database_helper.dart';
import '../models/task.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<int> addTask(Task task) async {
    final db = await _dbHelper.database;
    return await db.insert('tasks', task.toMap());
  }

  @override
  Future<List<Task>> getTasks(int groupId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
    );
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  @override
  Future<int> deleteTask(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> updateTask(Task task) async {
    final db = await _dbHelper.database;
    return await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  @override
  Future<int> toggleTaskCompletion(int taskId, bool isComplete) async {
    final db = await _dbHelper.database;
    return await db.update(
      'tasks',
      {'isComplete': isComplete ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  @override
  Future<Task?> getTask(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
