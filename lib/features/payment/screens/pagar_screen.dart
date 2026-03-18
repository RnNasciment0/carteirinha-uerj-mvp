import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_user.dart';

class PagarScreen extends StatefulWidget {
  const PagarScreen({super.key});

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  int tempoRestante = 30;
  late Timer _timer;
  String dadosQrCode = "";

  @override
  void initState() {
    super.initState();
    _gerarNovoQrCode();
    _iniciarTimer();
  }

  void _iniciarTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (tempoRestante > 0) {
          tempoRestante--;
        } else {
          tempoRestante = 30;
          _gerarNovoQrCode();
        }
      });
    });
  }

  void _gerarNovoQrCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    // O backend da catraca leria isso para saber quem é o aluno e descontar o saldo se necessário
    dadosQrCode = "PAGAMENTO_${simularEstudante.ID}_$timestamp";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LÓGICA DE COTISTA: Define os textos e cores dependendo do status
    String mensagemPagamento = simularEstudante.isCotista
        ? "Acesso Gratuito (Bolsista/Cotista)"
        : "Valor da Refeição: R\$ 2,00"; // Valor de exemplo

    Color corMensagem = simularEstudante.isCotista ? Colors.green : AppColors.azulUerj;

    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Pagamento Restaurante', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // O container abraça o conteúdo
              children: [
                Text(
                  mensagemPagamento,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corMensagem),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Se não for cotista, mostra o saldo na tela para o aluno saber
                if (!simularEstudante.isCotista)
                  Text(
                    "Saldo atual: R\$ ${simularEstudante.saldo.toStringAsFixed(2).replaceAll('.', ',')}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                const SizedBox(height: 30),

                // QR Code
                QrImageView(
                  data: dadosQrCode,
                  version: QrVersions.auto,
                  size: 200.0,
                  foregroundColor: AppColors.textoPrimario,
                ),

                const SizedBox(height: 20),

                Text(
                  'Aproxime do leitor da catraca',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 10),

                Text(
                    'Atualiza em: ${tempoRestante}s',
                    style: TextStyle(
                        color: tempoRestante <= 5 ? Colors.red : Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}