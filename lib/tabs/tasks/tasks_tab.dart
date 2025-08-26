import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/tabs/tasks/task_item.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

class TasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    return SafeArea(
      child: Column(
        children: [
          EasyInfiniteDateTimeLine(
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            focusDate: tasksProvider.selectedDate,
            lastDate: DateTime.now().add(Duration(days: 365)),
            showTimelineHeader: false,
            onDateChange: (selectedDate) {
              tasksProvider.changeSelectedDate(selectedDate);
              tasksProvider.getTasks();
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 20),
              itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
              itemCount: tasksProvider.tasks.length,
            ),
          ),
        ],
      ),
    );
  }
}
