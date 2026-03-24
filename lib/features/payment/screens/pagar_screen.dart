import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Importação necessária para gerar o QR Code
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';
import 'recarga_screen.dart';

class PagarScreen extends StatefulWidget {
  const PagarScreen({super.key});

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  bool _processando = false;
  String _metodoSelecionado = 'NFC'; // Variável que controla qual tela mostrar ('NFC' ou 'QR')

  void _simularPagamento() async {
    setState(() { _processando = true; });

    // Simula o tempo de leitura da catraca do bandejão
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // A MÁGICA DA VERIFICAÇÃO CONTINUA AQUI
    bool sucesso = AppData.instance.registrarPagamento();

    setState(() { _processando = false; });

    if (sucesso) {
      String nomeMetodo = _metodoSelecionado == 'NFC' ? 'Aproximação' : 'QR Code';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pagamento via $nomeMetodo aprovado! Bom apetite.'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      _mostrarAlertaSaldoInsuficiente();
    }
  }

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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: AppColors.textoSecundario))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.azulUerj, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RecargaScreen()));
            },
            child: const Text('Recarregar Pix', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- COMPONENTE VISUAL DO BOTÃO DE ESCOLHA (TOGGLE) ---
  Widget _buildBotaoMetodo(String titulo, IconData icone, String valor) {
    bool selecionado = _metodoSelecionado == valor;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() { _metodoSelecionado = valor; });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selecionado ? AppColors.azulUerj : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selecionado ? AppColors.azulUerj : Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icone, color: selecionado ? Colors.white : Colors.grey, size: 28),
              const SizedBox(height: 5),
              Text(titulo, style: TextStyle(color: selecionado ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
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
              // --- A BARRA DE SELEÇÃO NO TOPO ---
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    _buildBotaoMetodo('Aproximação', Icons.contactless, 'NFC'),
                    const SizedBox(width: 4),
                    _buildBotaoMetodo('QR Code', Icons.qr_code_2, 'QR'),
                  ],
                ),
              ),

              const Spacer(),

              // --- ÁREA DINÂMICA (Muda conforme a escolha do aluno) ---
              if (_metodoSelecionado == 'NFC') ...[
                // DESIGN DO NFC
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.azulUerj.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)]),
                  child: Icon(Icons.tap_and_play, size: 100, color: _processando ? Colors.grey : AppColors.azulUerj),
                ),
                const SizedBox(height: 40),
                Text(
                  _processando ? 'Processando pagamento...' : 'Aproxime o celular da catraca',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: AppColors.textoSecundario, fontWeight: FontWeight.bold),
                ),
              ] else ...[
                // DESIGN DO QR CODE
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)]),
                  child: QrImageView(
                    // Gera um QR Code único para essa transação misturando a matrícula e a hora atual
                    data: 'PGTO_UERJ_${AppData.instance.matricula}_${DateTime.now().millisecondsSinceEpoch}',
                    version: QrVersions.auto,
                    size: 180.0,
                    foregroundColor: AppColors.azulUerj,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _processando ? 'Lendo QR Code...' : 'Apresente este código\nno leitor da catraca',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: AppColors.textoSecundario, fontWeight: FontWeight.bold),
                ),
              ],

              const Spacer(),

              // --- O BOTÃO DE SIMULAÇÃO INTELIGENTE ---
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.azulUerj, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _processando ? null : _simularPagamento,
                  child: _processando
                      ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : Text(
                      _metodoSelecionado == 'NFC' ? 'SIMULAR APROXIMAÇÃO' : 'SIMULAR LEITURA DO QR',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}