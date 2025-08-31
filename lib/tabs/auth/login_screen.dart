import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/auth/register_screen.dart';
import 'package:todo_app/tabs/auth/user_provider.dart';
import 'package:todo_app/tabs/tasks/default_elevated_button.dart';
import 'package:todo_app/tabs/tasks/default_text_form_field.dart';

import '../../firebase_functions.dart';
import '../../home_screen.dart';
import '../../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.login,
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
                      Text(
                        AppLocalizations.of(context)!.welcomeBack,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.deepBlue,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to continue",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // Email
                      DefaultTextFormField(
                        controller: emailController,
                        hintText: AppLocalizations.of(context)!.email,
                        hintStyle: TextStyle(color:
                        AppTheme.black,
                        ),
                        validator: (value) {
                          if (value == null || value
                              .trim()
                              .length < 5) {
                            return 'Email cannot be less than 5 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password
                      DefaultTextFormField(
                        isPassword: true,
                        controller: passwordController,
                        hintText: AppLocalizations.of(context)!.password,
                        hintStyle: TextStyle(color:
                        AppTheme.black,
                        ),
                        validator: (value) {
                          if (value == null || value
                              .trim()
                              .length < 8) {
                            return AppLocalizations.of(context)!
                                .passwordMustBeAtLeast8Characters;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      DefaultElevatedButton(
                          label: AppLocalizations.of(context)!.login,
                          onPressed: login),
                      const SizedBox(height: 18),

                      // Register Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dontHaveAccount,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(RegisterScreen.routeName);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.register,
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

  void login() {
    if (formKey.currentState!.validate()) {
      if (formKey.currentState!.validate()) {
        FirebaseFunctions.login(
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
              msg: message ?? "Something went wrong!",
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
}
