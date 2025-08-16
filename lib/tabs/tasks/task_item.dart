import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/models/task_model.dart';

class TaskItem extends StatelessWidget {
  TaskItem(this.task);

  TaskModel task;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppTheme.white,
      ),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 4,
            color: AppTheme.primary,
            margin: EdgeInsetsDirectional.only(end: 8),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: textTheme.titleMedium),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: 34,
            width: 69,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.primary,
            ),
            child: Icon(Icons.check, color: AppTheme.white, size: 32),
          ),
        ],
      ),
    );
  }
}
