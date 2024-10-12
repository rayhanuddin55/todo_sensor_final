import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_sensor/generated/assets.dart';
import '../data/models/task.dart';
import '../data/models/task_group.dart';
import '../di.dart';
import '../repository/task_group_repository.dart';
import '../repository/task_repository.dart';

final tasksAndGroupsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final taskGroupRepository = getIt.get<ITaskGroupRepository>();
  final taskRepository = getIt.get<ITaskRepository>();

  final taskGroups = await taskGroupRepository.getTaskGroups();
  final tasks = await taskRepository.getAllTasks();

  return {
    'taskGroups': taskGroups,
    'tasks': tasks,
  };
});

class TodoHome extends ConsumerWidget {
  const TodoHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAndGroupsAsyncValue = ref.watch(tasksAndGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: tasksAndGroupsAsyncValue.when(
          data: (data) {
            final taskGroups = data['taskGroups'] as List<TaskGroup>;
            final tasks = data['tasks'] as List<Task>;

            if (taskGroups.isEmpty) {
              return const Center(child: Text('No task groups available'));
            }

            return ListView.builder(
              itemCount: taskGroups.length,
              itemBuilder: (context, index) {
                final group = taskGroups[index];
                final groupTasks =
                    tasks.where((task) => task.groupId == group.id);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () {
                      context.pushNamed(
                        "taskListDetails",
                        pathParameters: {"groupId": group.id.toString()},
                      );
                    },
                    leading: SvgPicture.asset(Assets.iconsIcList),
                    title: Text(
                      group.name,
                      style: GoogleFonts.inter().copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      "${groupTasks.length}",
                      style: GoogleFonts.inter().copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed("taskListDetails", pathParameters: {
            "groupId": "-1"
          }); // Navigate to add new task group
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
