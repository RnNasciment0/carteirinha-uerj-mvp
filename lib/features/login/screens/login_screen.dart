import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';
import '../../home/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String _mensagemErro = '';

  void _fazerLogin() {
    String matriculaDigitada = _matriculaController.text.trim();
    String senhaDigitada = _senhaController.text.trim();

    if (matriculaDigitada.isEmpty || senhaDigitada.isEmpty) {
      setState(() { _mensagemErro = 'Preencha todos os campos'; });
    }
    // --- AQUI ACONTECE A MÁGICA ---
    // Tentamos fazer o login no AppData com a matrícula digitada
    else if (AppData.instance.realizarLogin(matriculaDigitada)) {
      // Se a função retornar "true", a matrícula existe e os dados foram carregados!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() { _mensagemErro = 'Matrícula não encontrada no sistema'; });
    }
  }

  @override
  void dispose() {
    _matriculaController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.corFundo,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance, size: 100, color: AppColors.azulUerj),
              const SizedBox(height: 20),
              const Text('Acesso Aluno UERJ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.azulUerj)),
              const SizedBox(height: 40),
              TextField(
                controller: _matriculaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Matrícula',
                  prefixIcon: const Icon(Icons.badge, color: AppColors.azulUerj),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.azulUerj, width: 2)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha do Aluno Online',
                  prefixIcon: const Icon(Icons.lock, color: AppColors.azulUerj),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.azulUerj, width: 2)),
                ),
              ),
              const SizedBox(height: 10),
              if (_mensagemErro.isNotEmpty)
                Text(_mensagemErro, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulUerj,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _fazerLogin,
                  child: const Text('ENTRAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),

              // --- DICA PARA A APRESENTAÇÃO ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: const Column(
                  children: [
                    Text('Matrículas para teste do MVP:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoSecundario)),
                    SizedBox(height: 5),
                    Text('202520401811 (Não Cotista)', style: TextStyle(color: AppColors.textoSecundario)),
                    Text('12345 (Cotista)', style: TextStyle(color: AppColors.textoSecundario)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}