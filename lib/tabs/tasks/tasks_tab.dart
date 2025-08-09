import 'package:flutter/material.dart';
import 'package:todo_app/tabs/tasks/task_item.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, index) => TaskItem(),
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
