import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 0, 101, 155),
    error: const Color.fromARGB(255, 237, 11, 41),
    primary: const Color.fromARGB(255, 0, 135, 208),
  ),
);
