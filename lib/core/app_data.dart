import 'package:flutter/material.dart';

class Transacao {
  final String descricao;
  final double valor;
  final DateTime data;
  final bool ehSaida;
  final IconData icone;

  Transacao({required this.descricao, required this.valor, required this.data, required this.ehSaida, required this.icone});
}

class AppData {
  AppData._();
  static final AppData instance = AppData._();

  // Deixamos as variáveis vazias inicialmente, elas serão preenchidas no Login
  String nomeAluno = '';
  String matricula = '';
  String curso = '';
  String status = 'ATIVO';
  String foto = 'assets/images/profile_placeholder.png'; // Usamos a mesma foto padrão para não quebrar o app
  bool isCotista = false;
  double saldo = 0.0;
  List<Transacao> transacoes = [];

  // --- AS DUAS MATRÍCULAS DE TESTE ---
  static const String matriculaRenan = '202520401811'; // Você (Não Cotista)
  static const String matriculaMaria = '12345';        // Fictícia (Cotista)

  // Função que carrega o perfil baseado em quem entrou
  bool realizarLogin(String matriculaDigitada) {
    if (matriculaDigitada == matriculaRenan) {
      // PERFIL 1: RENAN (NÃO COTISTA)
      nomeAluno = 'Renan Souza do Nascimento';
      matricula = matriculaRenan;
      curso = 'Ciência da Computação';
      isCotista = false;
      saldo = 15.50;
      transacoes = [
        Transacao(descricao: 'Recarga Pix (App)', valor: 20.00, data: DateTime.now().subtract(const Duration(days: 1)), ehSaida: false, icone: Icons.pix),
      ];
      return true; // Login com sucesso

    } else if (matriculaDigitada == matriculaMaria) {
      // PERFIL 2: MARIA (COTISTA)
      nomeAluno = 'Maria Silva (Bolsista)';
      matricula = matriculaMaria;
      curso = 'Direito';
      isCotista = true;
      saldo = 0.00; // Cotista não precisa de saldo para comer
      transacoes = []; // Começa com extrato vazio
      return true; // Login com sucesso
    }

    return false; // Se digitar qualquer outra coisa, falha o login
  }

  void registrarPagamento() {
    // Só desconta saldo se NÃO for cotista
    if (!isCotista) {
      saldo -= 2.00;
      transacoes.insert(0, Transacao(descricao: 'Refeição - Bandejão (Simulação)', valor: 2.00, data: DateTime.now(), ehSaida: true, icone: Icons.contactless));
    } else {
      // Se for cotista, registra no extrato que ela comeu, mas o valor é 0.00 (Gratuito)
      transacoes.insert(0, Transacao(descricao: 'Refeição - Bandejão (Bolsista)', valor: 0.00, data: DateTime.now(), ehSaida: true, icone: Icons.contactless));
    }
  }
  void registrarRecarga(double valor){
    saldo += valor;
    transacoes.insert(0, Transacao(descricao: 'Recarga Pix (App)', valor: valor, data: DateTime.now(), ehSaida: false, icone: Icons.pix));
  }
}