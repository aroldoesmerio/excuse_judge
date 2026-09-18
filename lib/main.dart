import 'package:flutter/material.dart';

import 'features/tribunal/presentation/pages/tribunal_page.dart';

void main() {
  runApp(const ExcuseJudgeApp());
}

class ExcuseJudgeApp extends StatelessWidget {
  const ExcuseJudgeApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tribunal das Desculpas',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5A3E2B),
          secondary: Color(0xFFD6A84F),
          surface: Color(0xFFFFFCF7),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F3EA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F3EA),
          foregroundColor: Color(0xFF5A3E2B),
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFCF7),
          elevation: 3,
          shadowColor: const Color(0x335A3E2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFCF7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFD8CDBD),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF5A3E2B),
              width: 2,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A3E2B),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF5A3E2B),
            side: const BorderSide(
              color: Color(0xFF5A3E2B),
              width: 1.5,
            ),
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFFFFCF7),
          side: const BorderSide(
            color: Color(0xFFD8CDBD),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF5A3E2B),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        useMaterial3: true,
      ),
      home: const TribunalPage(),
    );
  }
}