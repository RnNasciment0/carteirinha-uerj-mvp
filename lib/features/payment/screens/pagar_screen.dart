import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';
import 'recarga_screen.dart'; // Importamos a tela de recarga

class PagarScreen extends StatefulWidget {
  const PagarScreen({super.key});

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  bool _processando = false;

  void _simularPagamento() async {
    setState(() { _processando = true; });

    // Simula o tempo de leitura da catraca do bandejão (1.5 segundos)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // --- A MÁGICA DA VERIFICAÇÃO AQUI ---
    // Tentamos pagar. O cérebro responde se deu certo ou não.
    bool sucesso = AppData.instance.registrarPagamento();

    setState(() { _processando = false; });

    if (sucesso) {
      // Se aprovou, mostra a mensagem verde e volta pra Home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pagamento aprovado! Bom apetite.'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Fecha a tela de pagamento
    } else {
      // Se reprovou, mostra o modal de Saldo Insuficiente
      _mostrarAlertaSaldoInsuficiente();
    }
  }

  // Modal (Pop-up) amigável de erro
  void _mostrarAlertaSaldoInsuficiente() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text('Saldo Insuficiente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
            ]
        ),
        content: const Text('Você não tem saldo suficiente para pagar esta refeição (R\$ 2,00). Deseja recarregar sua carteirinha agora?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textoSecundario))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.azulUerj, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context); // Fecha o aviso
              // Redireciona direto para a tela de Recarga Pix
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RecargaScreen()));
            },
            child: const Text('Recarregar Pix', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Pagar Bandejão', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.azulUerj.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)]),
                child: Icon(Icons.tap_and_play, size: 100, color: _processando ? Colors.grey : AppColors.azulUerj),
              ),
              const SizedBox(height: 40),
              Text(
                _processando ? 'Processando pagamento...' : 'Aproxime o celular da catraca\nou clique no botão abaixo',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: AppColors.textoSecundario, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),

              // O Botão que aciona a catraca simulada
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.azulUerj, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _processando ? null : _simularPagamento,
                  child: _processando
                      ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('SIMULAR APROXIMAÇÃO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}