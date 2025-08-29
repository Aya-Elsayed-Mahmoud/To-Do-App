import 'package:flutter/material.dart';

class DefaultTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final String? Function(String?)? validator;
  bool isPassword;

  DefaultTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.maxLines,
    this.isPassword = false,
  });

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines ?? 1,
      validator: widget.validator,

      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassword ? IconButton(onPressed: () {
          isObscure = !isObscure;
          setState(() {

          });
        },
            icon: isObscure ? Icon(Icons.visibility_off_outlined) : Icon(
                Icons.visibility_outlined)) : null,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

      ),
      obscureText: isObscure,
    );
  }
}
