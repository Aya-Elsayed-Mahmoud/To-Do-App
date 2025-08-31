import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';

class DefaultTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextStyle? hintStyle;

  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.maxLines,
    this.isPassword = false,
    this.hintStyle,
  });

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines ?? 1,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isObscure,
      style: widget.hintStyle,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon:
                      isObscure
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.visibility_outlined),
                )
                : null,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
