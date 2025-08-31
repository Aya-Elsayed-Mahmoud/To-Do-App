import 'package:flutter/material.dart';
import 'package:todo_app/firebase_functions.dart';

import '../../models/task_model.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  Future<void> getTasks(String userId) async {
    List<TaskModel> allTasks =
    await FirebaseFunctions.getAllTasksFromFirestore(userId);
    tasks =
        allTasks
            .where(
              (task) =>
                  task.date.day == selectedDate.day &&
                  task.date.month == selectedDate.month &&
                  task.date.year == selectedDate.year,
            )
            .toList();
    notifyListeners();
  }
}
