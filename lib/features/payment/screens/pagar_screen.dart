import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
// IMPORTAMOS O NOVO APP_DATA
import '../../../core/app_data.dart';

class PagarScreen extends StatefulWidget {
  const PagarScreen({super.key});

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  int tempoRestante = 30;
  late Timer _timer;
  String dadosQrCode = "";
  bool _pagamentoAprovado = false;

  @override
  void initState() {
    super.initState();
    _gerarNovoQrCode();
    _iniciarTimer();
  }

  void _iniciarTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_pagamentoAprovado) {
        setState(() {
          if (tempoRestante > 0) { tempoRestante--; } else { tempoRestante = 30; _gerarNovoQrCode(); }
        });
      }
    });
  }

  void _gerarNovoQrCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    // Pega a matrícula do AppData central
    dadosQrCode = "PAGAMENTO_${AppData.instance.matricula}_$timestamp";
  }

  // --- A MÁGICA CONECTADA AO EXTRATO ---
  void _simularPagamentoNfc() {
    if (_pagamentoAprovado) return;

    // Verifica saldo usando AppData central
    if (!AppData.instance.isCotista && AppData.instance.saldo < 2.00) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saldo insuficiente!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
      return;
    }

    // AVISA AO CÉREBRO QUE O PAGAMENTO OCORREU (Atualiza saldo e lista de extrato)
    AppData.instance.registrarPagamento();

    setState(() {
      _pagamentoAprovado = true; // Mostra tela de sucesso localmente
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) { setState(() { _pagamentoAprovado = false; tempoRestante = 30; _gerarNovoQrCode(); }); }
    });
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    // Pega os dados do AppData central
    bool isCotista = AppData.instance.isCotista;
    double saldoAtual = AppData.instance.saldo;

    String mensagemPagamento = isCotista ? "Acesso Gratuito (Bolsista/Cotista)" : "Valor da Refeição: R\$ 2,00";
    Color corMensagem = isCotista ? Colors.green : AppColors.azulUerj;

    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(backgroundColor: AppColors.azulUerj, title: const Text('Acesso ao Bandejão', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), iconTheme: const IconThemeData(color: Colors.white), elevation: 0,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity, padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _pagamentoAprovado ? _buildTelaSucesso() : _buildTelaPagamento(mensagemPagamento, corMensagem, saldoAtual, isCotista),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTelaPagamento(String mensagemPagamento, Color corMensagem, double saldoAtual, bool isCotista) {
    return Column(key: const ValueKey('tela_pagamento'), mainAxisSize: MainAxisSize.min,
      children: [
        Text(mensagemPagamento, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corMensagem), textAlign: TextAlign.center),
        const SizedBox(height: 5),

        if (!isCotista)
          Text("Saldo atual: R\$ ${saldoAtual.toStringAsFixed(2).replaceAll('.', ',')}", style: const TextStyle(fontSize: 16, color: AppColors.textoSecundario, fontWeight: FontWeight.bold)),

        const Divider(height: 40, thickness: 1),
        const Text('Aproxime o celular da catraca', style: TextStyle(color: AppColors.textoPrimario, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        GestureDetector(onTap: _simularPagamentoNfc, child: Container(padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: AppColors.azulUerj.withOpacity(0.1), shape: BoxShape.circle,), child: const Icon(Icons.contactless, size: 80, color: AppColors.azulUerj),),
        ),
        const SizedBox(height: 30),
        const Text('OU', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        const Text('Use o QR Code no leitor óptico', style: TextStyle(color: AppColors.textoSecundario, fontSize: 14)),
        const SizedBox(height: 10),
        QrImageView(data: dadosQrCode, version: QrVersions.auto, size: 120.0, foregroundColor: AppColors.textoPrimario),
        const SizedBox(height: 10),
        Text('Atualiza em: ${tempoRestante}s', style: TextStyle(color: tempoRestante <= 5 ? AppColors.vermelhoUerj : AppColors.douradoUerj, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTelaSucesso() {
    return Column(key: const ValueKey('tela_sucesso'), mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle, size: 100, color: Colors.green),),
        const SizedBox(height: 20),
        const Text('Catraca Liberada!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 10),
        if (!AppData.instance.isCotista) const Text('- RS 2,00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.vermelhoUerj)),
        const SizedBox(height: 40),
      ],
    );
  }
}