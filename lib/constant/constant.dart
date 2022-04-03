import 'package:flutter/material.dart';

class GradiantColors {
  static List<Color> sky1 = [Colors.lightBlueAccent, Color(0xffff8484)];
  static List<Color> sky2 = [Color(0xffca84ff), Color(0xff84ffd7)];
  static List<Color> sky3 = [Color(0xff84ffd7), Color(0xffff84e2)];
  static List<Color> sky4 = [Color(0xffff84e2), Color(0xff84c9ff)];
  static List<Color> sky5 = [Color(0xff84c9ff), Color(0xfff6ff15)];
}

//
ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  shadowColor: Colors.white,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
);
ThemeData lightTheme = ThemeData(
    primaryColor: Colors.black,
    shadowColor: Colors.black,
    scaffoldBackgroundColor: Color(0xffffffff),
    backgroundColor: Color(0xffffffff),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: const Color(0xffffffff)));
