import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';
import 'login_screen.dart';
import '../../home/screens/home_screen.dart'; // Importamos a Home para pular direto para lá

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacidade = 0.0;

  @override
  void initState() {
    super.initState();
    _iniciarAnimacao();
    _verificarSessaoENavegar(); // --- CHAMADA DA NOVA LÓGICA MÁGICA ---
  }

  void _iniciarAnimacao() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacidade = 1.0;
        });
      }
    });
  }

  // --- O CÉREBRO DA NAVEGAÇÃO ---
  void _verificarSessaoENavegar() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      // Pergunta pro AppData: "Alguém deixou o app logado?"
      bool sessaoAtiva = AppData.instance.isSessaoAtiva;
      String? ultimaMatricula = AppData.instance.ultimaMatriculaLogada;

      if (sessaoAtiva && ultimaMatricula != null) {
        // Se sim, faz um "Login Silencioso" e pula pra Home!
        AppData.instance.realizarLogin(ultimaMatricula);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      } else {
        // Se não (fez logout ou primeira vez), vai pra tela de Login
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulUerj,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacidade,
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeIn,
              child: Image.asset(
                'assets/images/uerj_logo.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance, size: 100, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Carteirinha Digital UERJ', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            const Text('Carregando dados...', style: TextStyle(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}