import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const NeonTaskManagerApp());
}

class NeonTaskManagerApp extends StatelessWidget {
  const NeonTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeonFlow Tasks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.vibrantTheme,
      home: const AuthScreen(),
    );
  }
}