import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_sensor/router.dart';

import '../../data/models/task.dart';

class ItemTask extends HookWidget {
  Task task;
  Function onCompleteChange;

  ItemTask({
    super.key,
    required this.task,
    required this.onCompleteChange,
  });

  @override
  Widget build(BuildContext context) {
    final isChecked = useState(task.isComplete);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {
          context.pushNamed(
            "taskDetails",
            pathParameters: {"taskId": task.id.toString()},
          );
        },
        leading: Checkbox(
          value: isChecked.value,
          onChanged: (value) {
            onCompleteChange();
            isChecked.value = !isChecked.value;
          },
        ),
        title: Text(
          task.title ?? "--",
          style: GoogleFonts.inter().copyWith(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_month,
              size: 12,
              color: Color(0xffB9B9BE),
            ),
            const SizedBox(width: 5),
            Text(
              task.dueDate != null
                  ? DateFormat('EEE, dd MMM').format(task.dueDate!)
                  : "--",
              // Replace this with actual group-related date information
              style: GoogleFonts.inter().copyWith(
                color: const Color(0xffB9B9BE),
                fontSize: 10,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.star),
      ),
    );
  }
}
