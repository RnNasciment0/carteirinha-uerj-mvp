import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
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

  final LocalAuthentication _auth = LocalAuthentication();

  void _fazerLoginComSenha() {
    String matriculaDigitada = _matriculaController.text.trim();
    String senhaDigitada = _senhaController.text.trim();

    if (matriculaDigitada.isEmpty || senhaDigitada.isEmpty) {
      setState(() { _mensagemErro = 'Preencha todos os campos'; });
    } else if (AppData.instance.realizarLogin(matriculaDigitada)) {
      _navegarParaHome();
    } else {
      setState(() { _mensagemErro = 'Matrícula não encontrada no sistema'; });
    }
  }

  Future<void> _fazerLoginComBiometria() async {
    // --- VERIFICAÇÃO INTELIGENTE ANTES DE ABRIR O SENSOR ---
    String? ultimaMatricula = AppData.instance.ultimaMatriculaLogada;

    if (ultimaMatricula == null || ultimaMatricula.isEmpty) {
      // Se não há memória de ninguém no disco, bloqueia a biometria
      setState(() {
        _mensagemErro = 'Nenhuma conta vinculada.\nFaça o login com matrícula e senha pela primeira vez para ativar a biometria.';
      });
      return;
    }

    bool autenticado = false;

    try {
      final bool podeAutenticar = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

      if (podeAutenticar) {
        autenticado = await _auth.authenticate(
          localizedReason: 'Toque no sensor para acessar sua Carteirinha Digital',
          biometricOnly: false,
          persistAcrossBackgrounding: true,
        );
      } else {
        setState(() { _mensagemErro = 'Biometria não disponível neste dispositivo.'; });
        return;
      }
    } on PlatformException catch (e) {
      print("Erro de Biometria: ${e.code} - ${e.message}");
      setState(() { _mensagemErro = 'Autenticação cancelada ou falhou.'; });
      return;
    }

    if (autenticado && mounted) {
      // --- LOGIN DINÂMICO USANDO A ÚLTIMA MATRÍCULA SALVA NO DISCO ---
      if (AppData.instance.realizarLogin(ultimaMatricula)) {
        _navegarParaHome();
      } else {
        setState(() { _mensagemErro = 'Erro ao carregar a conta vinculada.'; });
      }
    }
  }

  void _navegarParaHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
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
              Image.asset(
                'assets/images/uerj_logo.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance, size: 100, color: AppColors.azulUerj),
              ),
              const SizedBox(height: 30),
              const Text('Acesso Aluno UERJ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.azulUerj)),
              const SizedBox(height: 40),

              TextField(
                controller: _matriculaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Matrícula',
                    prefixIcon: const Icon(Icons.badge, color: AppColors.azulUerj),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.azulUerj, width: 2))
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
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.azulUerj, width: 2))
                ),
              ),
              const SizedBox(height: 10),

              if (_mensagemErro.isNotEmpty)
                Text(_mensagemErro, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.azulUerj, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: _fazerLoginComSenha,
                        child: const Text('ENTRAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  SizedBox(
                    height: 55, width: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.douradoUerj,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _fazerLoginComBiometria,
                      child: const Icon(Icons.fingerprint, size: 35, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                  child: const Column(
                      children: [
                        Text('Matrículas para teste do MVP:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoSecundario)),
                        SizedBox(height: 5),
                        Text('202520401811 (Não Cotista)', style: TextStyle(color: AppColors.textoSecundario)),
                        Text('12345 (Cotista)', style: TextStyle(color: AppColors.textoSecundario))
                      ]
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}