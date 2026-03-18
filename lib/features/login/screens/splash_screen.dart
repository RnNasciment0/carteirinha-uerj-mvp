import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacidade = 0.0; // Começa invisível para a animação

  @override
  void initState() {
    super.initState();
    _iniciarAnimacao();
    _navegarParaLogin();
  }

  // Função que faz a logo aparecer suavemente (Fade-In)
  void _iniciarAnimacao() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacidade = 1.0; // Fica totalmente visível
        });
      }
    });
  }

  // Função que espera 3 segundos e vai para a tela de Login
  void _navegarParaLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          // Transição de página suave (FadeTransition) para o Login
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
      // Fundo Azul Vibrante da UERJ
      backgroundColor: AppColors.azulUerj,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container Animado para o Fade-In da logo
            AnimatedOpacity(
              opacity: _opacidade,
              duration: const Duration(milliseconds: 1500), // Duração do Fade-In
              curve: Curves.easeIn,
              child: Image.asset(
                'assets/images/uerjLogoSplash.jpg', // Puxa a logo da UERJ
                height: 150, // Altura maior na Splash
                // errorBuilder: caso a imagem não carregue, mostra um ícone genérico
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance, size: 100, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            // Texto de Carregando (pode ser o nome do app ou da UERJ)
            const Text(
              'Carteirinha Digital UERJ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Carregando dados...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}