import 'package:flutter/material.dart';
import 'core/app_data.dart'; // Importação do AppData
import 'features/login/screens/splash_screen.dart';

// Transformamos a função main em Assíncrona (Future)
void main() async {
  // 1. Garante que o Flutter esteja totalmente inicializado nativamente
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Chama a função init do nosso cérebro para carregar o Shared Preferences do disco
  await AppData.instance.init();

  // 3. Só então abre o aplicativo
  runApp(const MeuAppUerj());
}

class MeuAppUerj extends StatelessWidget {
  const MeuAppUerj({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carteirinha Digital UERJ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0072CE)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}