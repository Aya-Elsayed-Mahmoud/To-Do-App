import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/tasks/default_elevated_button.dart';
import 'package:todo_app/tabs/tasks/default_text_form_field.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              'Add new Task',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.black),
            ),
            const SizedBox(height: 16),
            DefaultTextFormField(
              controller: titleController,
              hintText: 'Enter task title',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title can not be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DefaultTextFormField(
              controller: descriptionController,
              hintText: 'Enter task description',
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description can not be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text('Select date', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                DateTime? dateTime = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  initialDate: selectedDate,
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                );
                if (dateTime != null) {
                  setState(() {
                    selectedDate = dateTime;
                  });
                }
              },
              child: Text(
                dateFormat.format(selectedDate),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.black,
                ),
              ),
            ),
            const SizedBox(height: 32),
            DefaultElevatedButton(
              label: 'Submit',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  addTask();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void addTask() {
    FirebaseFunctions.addTaskToFirestore(
        TaskModel(
            title: titleController.text,
            description: descriptionController.text,
            date: selectedDate)).timeout(
        Duration(microseconds: 500),
        onTimeout: () {
          Navigator.of(context).pop();
          Provider.of<TasksProvider>(context, listen: false).getTasks();
          Fluttertoast.showToast(
              msg: "Task added successfully",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 5,
              backgroundColor: AppTheme.green,
              textColor: AppTheme.white,
              fontSize: 16
          );
        }
    ).
    catchError((_) {
      Fluttertoast.showToast(
          msg: "Something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
          textColor: AppTheme.white,
          fontSize: 16
      );
    });
  }
}
