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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const TribunalPage(),
    );
  }
}