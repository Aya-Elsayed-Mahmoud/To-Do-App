import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

class TaskItem extends StatefulWidget {
  TaskItem(this.task, {super.key});
  TaskModel task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 10),
      child: Slidable(
        //key: const ValueKey(0),
        startActionPane: ActionPane(motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                FirebaseFunctions.deleteTaskToFirestore(widget.task.id).
                timeout(Duration(microseconds: 500),
                    onTimeout: () {
                      Provider
                          .of<TasksProvider>(context, listen: false)
                          .getTasks();
                      Fluttertoast.showToast(
                          msg: "Task delete successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 5,
                          backgroundColor: AppTheme.green,
                          textColor: AppTheme.white,
                          fontSize: 16
                      );
                    }
                ).catchError((error) {
                  Fluttertoast.showToast(
                      msg: "Something went wrong!",
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 5,
                      backgroundColor: AppTheme.red,
                      textColor: AppTheme.white,
                      fontSize: 16);
                });
              },
            )
          ],
        ),
        child:
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppTheme.white,
          ),
          child: Row(
            children: [
              Container(
                height: 62,
                width: 4,
                color: widget.task.isDone ? AppTheme.green : AppTheme.primary,
                margin: const EdgeInsetsDirectional.only(end: 8),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: textTheme.titleMedium?.copyWith(
                      decoration: widget.task.isDone ? TextDecoration
                          .lineThrough : null,
                      color: widget.task.isDone ? Colors.grey : AppTheme.black,
                    ),
                  ),
                  Text(
                    widget.task.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: widget.task.isDone ? Colors.grey : AppTheme.black,
                      decoration: widget.task.isDone ? TextDecoration
                          .lineThrough : null,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    widget.task.isDone = !widget.task.isDone;
                  });
                  await FirebaseFunctions.updateTask(widget.task);
                  if (!mounted) return;
                  Provider.of<TasksProvider>(context, listen: false).getTasks();
                },
                child: widget.task.isDone
                    ? const Text(
                  "Done!",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : Container(
                  height: 34,
                  width: 69,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.primary,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
