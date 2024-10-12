import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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

import '../../data/models/task.dart';
import '../../data/models/task_group.dart';
import '../../utils/local_notification_service.dart';
import '../../utils/show_notification.dart';

class TaskDetails extends HookConsumerWidget {
  int taskId;

  final taskRepository = getIt.get<ITaskRepository>();

  TaskDetails({super.key, this.taskId = -1});

  Future<void> updateTask(Task task) async {
    await taskRepository.updateTask(task);
  }

  @override
  Widget build(BuildContext context, ref) {

    final taskController = useTextEditingController();
    final taskNoteController = useTextEditingController();

    final selectedDate = useState<DateTime?>(null);

    final task = useState<Task?>(null);

    getTask() async {
      task.value = await taskRepository.getTask(taskId);

      selectedDate.value = task.value?.dueDate;
      taskNoteController.text = task.value?.note ?? "";
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
        await taskRepository.updateTask(task.value!.copyWith(
          dueDate: selectedDate.value,
        ));

        getIt<LocalNotificationService>().cancelNotification(task.value!.id!);

        showNotification(
          id: task.value!.id!,
          title: "Task",
          body: taskController.text,
          delay: DateTime.now().difference(selectedDate.value!).inSeconds,
        );
      }
    }

    Future<void> showAlertDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Are you sure you want to delete "${task.value?.title}"?'),
                  //Text('Would you like to approve of this message?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  context.pop();
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  await taskRepository.deleteTask(task.value!.id!);
                  ref.invalidate(taskNotifierProvider);
                  context.pop();
                  context.pop();
                },
              ),
            ],
          );
        },
      );
    }

    useEffect(() {
      getTask();
      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(task.value?.title ?? "--"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          Assets.iconsIcReminder,
                        ),
                      ),
                      Text(
                        "Remind Me",
                        style: GoogleFonts.inter().copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                              : "Due Date",
                          style: TextStyle(
                            color: selectedDate.value != null
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          Assets.iconsIcNote,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Note',
                            hintStyle: GoogleFonts.inter().copyWith(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          controller: taskNoteController,
                          maxLines: 5,
                          onChanged: (value) {
                            EasyDebounce.debounce(
                                'tag', const Duration(milliseconds: 500),
                                () async {
                              await taskRepository
                                  .updateTask(task.value!.copyWith(
                                note: taskNoteController.text,
                              ));
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    showAlertDialog();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(Assets.iconsIcDelete),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Delete")
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
