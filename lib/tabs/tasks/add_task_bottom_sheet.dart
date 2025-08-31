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
import '../../l10n/app_localizations.dart';
import '../auth/user_provider.dart';

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
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery
          .of(context)
          .viewInsets
          .bottom),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.55,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.backgroundDark : AppTheme.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.addNewTask,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: titleController,
                hintText: AppLocalizations.of(context)!.enterTaskTitle,
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return AppLocalizations.of(context)!.titleCanNotBeEmpty;
                  }
                  return null;
                },
                hintStyle: TextStyle(
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: descriptionController,
                hintText: AppLocalizations.of(context)!.enterTaskDescription,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return AppLocalizations.of(context)!
                        .descriptionCanNotBeEmpty;
                  }
                  return null;
                },
                hintStyle: TextStyle(
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.selectDate,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(
                  color: isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color: isDark ? AppTheme.white : AppTheme.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              DefaultElevatedButton(
                label: "submit",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    addTask();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTask() async {
    try {
      final userId = Provider
          .of<UserProvider>(context, listen: false)
          .currentUser!
          .id;

      await FirebaseFunctions.addTaskToFirestore(
        TaskModel(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          date: selectedDate,
        ),
        userId,
      );

      await Provider.of<TasksProvider>(context, listen: false).getTasks(userId);

      Navigator.of(context).pop();

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.taskAddedSuccessfully,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: AppTheme.green,
        textColor: AppTheme.white,
        fontSize: 16,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: AppTheme.red,
        textColor: AppTheme.white,
        fontSize: 16,
      );
    }
  }
}
