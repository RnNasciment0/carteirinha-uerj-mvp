import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/login/screens/login_screen.dart';
import 'features/login/screens/splash_screen.dart';

void main() {
  runApp(const MeuAppUerj());
}

class MeuAppUerj extends StatelessWidget {
  const MeuAppUerj({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVP Carteirinha UERJ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.azulUerj,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.azulUerj),
        useMaterial3: true,
      ),
      // A primeira tela agora é a de Login!
      home: const SplashScreen(),
    );
  }
}