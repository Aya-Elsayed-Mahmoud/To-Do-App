import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/tabs/auth/login_screen.dart';
import 'package:todo_app/tabs/auth/user_provider.dart';
import 'package:todo_app/tabs/tasks/default_elevated_button.dart';
import 'package:todo_app/tabs/tasks/default_text_form_field.dart';

import '../../home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: AppTheme.deepBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.deepBlue),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Colors.white.withOpacity(0.85),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppTheme.deepBlue.withOpacity(0.06)),
              ),
              elevation: 8,
              shadowColor: AppTheme.deepBlue.withOpacity(0.12),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.deepBlue,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Create a new account to get started",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // Name
                      DefaultTextFormField(
                        controller: nameController,
                        hintText: 'Name',
                        validator: (value) {
                          if (value == null || value.trim().length < 3) {
                            return 'Name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Email
                      DefaultTextFormField(
                        controller: emailController,
                        hintText: 'Email',
                        validator: (value) {
                          if (value == null || value.trim().length < 5) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password
                      DefaultTextFormField(
                        isPassword: true,
                        controller: passwordController,
                        hintText: "Password",
                        validator: (value) {
                          if (value == null || value.trim().length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Confirm Password
                      DefaultTextFormField(
                        isPassword: true,
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      DefaultElevatedButton(
                        label: 'Create Account',
                        onPressed: register,
                      ),

                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(LoginScreen.routeName);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: AppTheme.deepBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      final user = FirebaseFunctions.register(name: nameController.text,
          email: emailController.text,
          password: passwordController.text).then((user) {
        Provider.of<UserProvider>(context, listen: false).updateUser(user);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }).catchError((error) {
        String? message;
        if (error is FirebaseAuthException) {
          message = error.message;
        }
        Fluttertoast.showToast(
            msg: "Something went wrong!",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 5,
            backgroundColor: AppTheme.red,
            textColor: AppTheme.white,
            fontSize: 16
        );
      });
    };
  }
  }

