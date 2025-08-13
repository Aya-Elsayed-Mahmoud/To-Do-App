import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;

  DefaultElevatedButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: AppTheme.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary,
        fixedSize: Size(MediaQuery.of(context).size.width, 52),
      ),
    );
  }
}
