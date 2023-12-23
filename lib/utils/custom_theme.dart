import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 0, 101, 155),
    error: Color.fromARGB(255, 234, 48, 73),
    primary: const Color.fromARGB(255, 0, 135, 208),
  ),
  primaryColor: Color.fromARGB(255, 11, 149, 223),
);
