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
import '../../l10n/app_localizations.dart';

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
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.createAccount,
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
                        AppLocalizations.of(context)!.welcome,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.deepBlue,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!
                            .createAnewAccountToGetStarted,
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
                        hintText: AppLocalizations.of(context)!.name,
                        hintStyle: TextStyle(color:
                        AppTheme.black,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 3) {
                            return AppLocalizations.of(context)!
                                .nameMustBeAtLeast3Characters;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Email
                      DefaultTextFormField(
                        controller: emailController,
                        hintText: AppLocalizations.of(context)!.email,
                        hintStyle: TextStyle(color:
                        AppTheme.black,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 5) {
                            return AppLocalizations.of(context)!
                                .enterAValidEmail;
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
                          if (value == null || value.trim().length < 8) {
                            return AppLocalizations.of(context)!
                                .passwordMustBeAtLeast8Characters;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Confirm Password
                      DefaultTextFormField(
                        isPassword: true,
                        controller: confirmPasswordController,
                        hintText: AppLocalizations.of(context)!.confirmPassword,
                        hintStyle: TextStyle(color:
                        AppTheme.black,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseConfirmYourPassword;
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      DefaultElevatedButton(
                        label: AppLocalizations.of(context)!.createAccount,
                        onPressed: register,
                      ),

                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.alreadyHaveAccount,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(LoginScreen.routeName);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.login,
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

