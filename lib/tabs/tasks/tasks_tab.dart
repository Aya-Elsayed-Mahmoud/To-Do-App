import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/tasks/task_item.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

import '../../l10n/app_localizations.dart';
import '../auth/user_provider.dart';

class TasksTab extends StatefulWidget {
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool shouldGetTasks = true;

  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    if (shouldGetTasks) {
      tasksProvider.getTasks(
        Provider
            .of<UserProvider>(context)
            .currentUser!
            .id,
      );
      shouldGetTasks = false;
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.15,
              width: double.infinity,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            PositionedDirectional(
              start: 20,
              top: 40,
              child: Text(
                AppLocalizations.of(context)!.todoList,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontSize: 20,
                  color: AppTheme.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: EasyInfiniteDateTimeLine(
                locale: Localizations
                    .localeOf(context)
                    .languageCode,
                // 👈 يخلي الكاليندر عربي/إنجليزي
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(const Duration(days: 365)),
                showTimelineHeader: false,
                onDateChange: (selectedDate) {
                  tasksProvider.changeSelectedDate(selectedDate);
                  tasksProvider.getTasks(
                    Provider
                        .of<UserProvider>(context, listen: false)
                        .currentUser!
                        .id,
                  );
                },
                activeColor: AppTheme.white,
                dayProps: EasyDayProps(
                  height: 90,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    dayStrStyle: const TextStyle(color: AppTheme.black),
                    monthStrStyle: const TextStyle(
                      color: AppTheme.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),

                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    dayStrStyle: const TextStyle(color: AppTheme.black),
                    monthStrStyle: const TextStyle(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
            itemCount: tasksProvider.tasks.length,
          ),
        ),
      ],
    );
  }
}
