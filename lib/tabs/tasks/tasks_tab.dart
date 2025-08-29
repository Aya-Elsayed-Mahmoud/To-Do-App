import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/tasks/task_item.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

class TasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    return Column(
        children: [
          Stack(children: [
            Container(height: MediaQuery
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
              child: Text('ToDo List',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                    fontSize: 20,
                    color: AppTheme.white),
              ),
            ),
            Padding(

              padding: const EdgeInsets.only(top: 100),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(Duration(days: 365)),
                showTimelineHeader: false,
                onDateChange: (selectedDate) {
                  tasksProvider.changeSelectedDate(selectedDate);
                  tasksProvider.getTasks();
                },
                activeColor: AppTheme.white,
                dayProps: EasyDayProps(
                  height: 90,
                  activeDayStyle: DayStyle(
                      decoration: BoxDecoration(color: AppTheme.white,
                          borderRadius: BorderRadius.circular(5)),
                      dayStrStyle: TextStyle(color: AppTheme.black),
                      monthStrStyle: TextStyle(color: Colors.transparent)
                  ),
                  inactiveDayStyle: DayStyle(
                      decoration: BoxDecoration(color: AppTheme.white,
                          borderRadius: BorderRadius.circular(5)),
                      dayStrStyle: TextStyle(color: AppTheme.black),
                      monthStrStyle: TextStyle(color: Colors.transparent)
                  ),
                ),
              ),
            ),
          ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 20),
              itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
              itemCount: tasksProvider.tasks.length,
            ),
          ),

        ],
    );
  }
}
