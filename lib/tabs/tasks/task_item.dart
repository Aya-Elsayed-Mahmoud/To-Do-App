import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import '../../l10n/app_localizations.dart';
import '../auth/user_provider.dart';
import 'edit_task_screen.dart';

class TaskItem extends StatefulWidget {
  final TaskModel task;

  const TaskItem(this.task, {super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final tasksProvider = Provider.of<TasksProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
              borderRadius: BorderRadius.circular(15),
              onPressed: (_) async {
                try {
                  await FirebaseFunctions.deleteTaskToFirestore(
                      widget.task.id, userProvider.currentUser!.id);
                  await tasksProvider.getTasks(userProvider.currentUser!.id);
                  Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!.taskDeleteSuccessfully,
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 2,
                    backgroundColor: AppTheme.green,
                    textColor: AppTheme.white,
                    fontSize: 16,
                  );
                } catch (error) {
                  Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!.somethingWentWrong,
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 2,
                    backgroundColor: AppTheme.red,
                    textColor: AppTheme.white,
                    fontSize: 16,
                  );
                }
              },
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditTaskScreen(task: widget.task),
              ),
            );
          },
          child: Container(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          decoration: widget.task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: widget.task.isDone
                              ? Colors.grey
                              : AppTheme.black,
                        ),
                      ),
                      Text(
                        widget.task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: widget.task.isDone
                              ? Colors.grey
                              : AppTheme.black,
                          decoration: widget.task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    setState(() {
                      widget.task.isDone = !widget.task.isDone;
                    });
                    await FirebaseFunctions.updateTask(
                        widget.task, userProvider.currentUser!.id);
                    if (!mounted) return;
                    await tasksProvider.getTasks(userProvider.currentUser!.id);
                  },
                  child: widget.task.isDone
                      ? Text(
                    AppLocalizations.of(context)!.done,
                    style: const TextStyle(
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
      ),
    );
  }
}
