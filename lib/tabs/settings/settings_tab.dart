import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/auth/login_screen.dart';
import 'package:todo_app/tabs/settings/app_provider.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/firebase_functions.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.settings, // ✅ تم استبدال النص الثابت
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseFunctions.logout();
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
            tooltip: AppLocalizations.of(context)!.logout, // ✅ Tooltip مترجم
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Language Section =====
            Text(
              AppLocalizations.of(context)!.language, // ✅ كلمة لغة مترجمة
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: appProvider.currentLocale.languageCode,
                isExpanded: true,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(AppLocalizations.of(context)!.english,
                        style: TextStyle(color:
                        AppTheme.primary)),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text(AppLocalizations.of(context)!.arabic,
                        style: TextStyle(color:
                        AppTheme.primary)),
                  ),
                ],
                onChanged: (value) {
                  appProvider.changeLanguage(value!);
                },
              ),
            ),

            const SizedBox(height: 30),
            Text(
              AppLocalizations.of(context)!.theme,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: appProvider.themeMode == ThemeMode.dark
                    ? 'dark'
                    : 'light',
                isExpanded: true,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: 'light',
                    child: Text(AppLocalizations.of(context)!.light,
                      style: TextStyle(color:
                      AppTheme.primary),
                    ),),
                  DropdownMenuItem(
                    value: 'dark',
                    child: Text(AppLocalizations.of(context)!.dark,
                        style: TextStyle(color:
                        AppTheme.primary)),
                  ),
                ],
                onChanged: (value) {
                  appProvider.toggleTheme(value == 'dark');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
