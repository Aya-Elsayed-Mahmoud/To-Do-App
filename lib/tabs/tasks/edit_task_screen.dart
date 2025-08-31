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

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    selectedDate = widget.task.date;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.todoList,
          style: TextStyle(color: isDark ? AppTheme.black : AppTheme.white),
        ),
        backgroundColor: isDark ? AppTheme.midBlue : AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Card(
            elevation: 6,
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.editTask,
                    style: TextStyle(
                      color: isDark ? AppTheme.white : AppTheme.black,
                    ),
                  ),

                  const SizedBox(height: 20),
                  DefaultTextFormField(
                    controller: titleController,
                    hintText: AppLocalizations.of(context)!.enterTaskTitle,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
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
                    hintText:
                        AppLocalizations.of(context)!.enterTaskDescription,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.descriptionCanNotBeEmpty;
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark ? AppTheme.white : AppTheme.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  DefaultElevatedButton(
                    label: AppLocalizations.of(context)!.saveChanges,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        updateTask();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateTask() async {
    try {
      final userId =
          Provider.of<UserProvider>(context, listen: false).currentUser!.id;

      widget.task.title = titleController.text.trim();
      widget.task.description = descriptionController.text.trim();
      widget.task.date = selectedDate;

      await FirebaseFunctions.updateTask(widget.task, userId);
      await Provider.of<TasksProvider>(context, listen: false).getTasks(userId);

      Navigator.of(context).pop();

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.taskUpdatedSuccessfully,
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
