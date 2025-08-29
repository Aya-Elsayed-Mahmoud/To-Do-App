import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF5D9CEC);
  static const Color backgroundLight = Color(0xFFDFECDB);
  static const Color backgroundDark = Color(0xFF141922);
  static const Color green = Color(0xFF61E757);
  static const Color grey = Color(0xFFC8C9CB);
  static const Color red = Color(0xFFEC4B4B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightBlueBg = Color(0xFFF2F7FF);
  static const Color deepBlue = Color(0xFF1D4ED8);
  static const Color midBlue = Color(0xFF2563EB);


  static ThemeData lightTheme = ThemeData(
      appBarTheme:
      AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true
      ),
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: white,
      unselectedItemColor: grey,
      selectedItemColor: primary,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
      shape: CircleBorder(side: BorderSide(color: white, width: 4)),
      elevation: 0,
    ),
      textTheme: TextTheme(
          titleMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primary
          ),
          titleSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: black
          )
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
          ),

      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary,)
      )

  );
  static ThemeData darkTheme = ThemeData();
}
