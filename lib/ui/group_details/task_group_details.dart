import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_sensor/di.dart';
import 'package:todo_sensor/generated/assets.dart';
import 'package:todo_sensor/repository/task_group_repository.dart';
import 'package:todo_sensor/repository/task_repository.dart';
import 'package:todo_sensor/ui/group_details/item_task.dart';
import 'package:todo_sensor/ui/group_details/task_notifier.dart';
import 'package:todo_sensor/ui/todo_home.dart';
import 'package:todo_sensor/utils/app_colors.dart';
import 'package:todo_sensor/utils/show_notification.dart';

import '../../data/models/task.dart';
import '../../data/models/task_group.dart';

class TaskGroupDetails extends HookConsumerWidget {
  int groupId;

  final taskRepository = getIt.get<ITaskRepository>();
  final taskGroupRepository = getIt.get<ITaskGroupRepository>();

  TaskGroupDetails({super.key, this.groupId = -1});

  Future<int?> addTask(
    WidgetRef ref,
    String? taskGroup,
    String taskTitle,
    DateTime? dueDate,
  ) async {
    try {
      if (groupId == -1) {
        TaskGroup newGroup = TaskGroup(name: taskGroup ?? 'New Group');
        int newGroupId = await taskGroupRepository.addTaskGroup(newGroup);

        groupId = newGroupId;
      }

      Task newTask = Task(
        title: taskTitle,
        groupId: groupId,
        dueDate: dueDate,
      );
      final id = await ref
          .read(taskNotifierProvider(groupId).notifier)
          .addTask(newTask);

      print('Task added successfully!');

      return id;
    } catch (error) {
      print('Error adding task: $error');
    }
  }

  Future<void> onAddTask(
    TextEditingController taskGroupController,
    TextEditingController taskController,
    DateTime? dueDate,
    WidgetRef ref,
  ) async {
    final id = await addTask(
      ref,
      taskGroupController.text,
      taskController.text,
      dueDate,
    );

    if (dueDate != null && id != null) {
      showNotification(
        id: id,
        title: "Task",
        body: taskController.text,
        delay: DateTime.now().difference(dueDate).inSeconds,
      );
    }

    taskController.clear();

    ref.invalidate(taskNotifierProvider);
    ref.invalidate(tasksAndGroupsProvider);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    await taskRepository.toggleTaskCompletion(task.id!, !task.isComplete);
  }

  @override
  Widget build(BuildContext context, ref) {
    final tasks = ref.watch(taskNotifierProvider(groupId));

    final activeAddTaskButton = useState(false);

    final showAddTask = useState(false);
    final focusNode = useFocusNode();

    final taskController = useTextEditingController();
    final taskGroupController = useTextEditingController();

    final selectedDate = useState<DateTime?>(null);

    getTaskGroup() async {
      taskGroupController.text =
          (await taskGroupRepository.getTaskGroup(groupId))?.name ?? "";
    }

    showDateDialog() async {
      final date = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );
      if (date != null) {
        selectedDate.value = date;
      }
    }

    useEffect(() {
      getTaskGroup();
      ref.invalidate(taskNotifierProvider);
      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lists"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'List Title',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    controller: taskGroupController,
                    onChanged: (value) {
                      EasyDebounce.debounce(
                          'tag', const Duration(milliseconds: 500), () async {
                        await taskGroupRepository.updateTaskGroup(TaskGroup(
                          id: groupId,
                          name: taskGroupController.text,
                        ));

                        ref.invalidate(tasksAndGroupsProvider);
                      });
                    },
                  ),
                  Expanded(
                      child: tasks.isEmpty
                          ? const Center(
                              child: Text('No task groups available'),
                            )
                          : ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return ItemTask(
                                    task: task,
                                    onCompleteChange: () {
                                      toggleTaskCompletion(task);
                                    });
                              },
                            )),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                focusNode.requestFocus();
                showAddTask.value = true;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_add_task.svg",
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text("Add a Task")
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showAddTask.value)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // height: 200,
                  // width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                            ),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Task',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                focusNode: focusNode,
                                controller: taskController,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    activeAddTaskButton.value = true;
                                  } else {
                                    activeAddTaskButton.value = false;
                                  }
                                },
                                onSubmitted: (value) {
                                  onAddTask(
                                    taskGroupController,
                                    taskController,
                                    selectedDate.value,
                                    ref,
                                  );
                                  activeAddTaskButton.value = false;
                                  selectedDate.value = null;
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (activeAddTaskButton.value) {
                                  onAddTask(
                                    taskGroupController,
                                    taskController,
                                    selectedDate.value,
                                    ref,
                                  );

                                  activeAddTaskButton.value = false;
                                  selectedDate.value = null;

                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                              icon: SvgPicture.asset(
                                Assets.iconsIcAddTask1,
                                colorFilter: ColorFilter.mode(
                                  !activeAddTaskButton.value
                                      ? Colors.grey
                                      : AppColors.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                Assets.iconsIcReminder,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                Assets.iconsIcNote,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDateDialog();
                              },
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      showDateDialog();
                                    },
                                    icon: SvgPicture.asset(
                                      Assets.iconsIcDate,
                                      colorFilter: ColorFilter.mode(
                                        selectedDate.value != null
                                            ? AppColors.primary
                                            : Colors.grey,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    selectedDate.value != null
                                        ? DateFormat('EEE, dd MMM')
                                            .format(selectedDate.value!)
                                        : "",
                                    style: TextStyle(color: AppColors.primary),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
