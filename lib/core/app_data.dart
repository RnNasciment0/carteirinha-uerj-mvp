import 'package:flutter/material.dart';

class Transacao {
  final String descricao;
  final double valor;
  final DateTime data;
  final bool ehSaida;
  final IconData icone;
  Transacao({required this.descricao, required this.valor, required this.data, required this.ehSaida, required this.icone});
}

// --- NOVO MODELO: NOTIFICAÇÃO ---
class Notificacao {
  final String titulo;
  final String mensagem;
  final DateTime data;
  bool lida;
  final IconData icone;
  final Color corIcone;

  Notificacao({
    required this.titulo,
    required this.mensagem,
    required this.data,
    this.lida = false,
    required this.icone,
    required this.corIcone,
  });
}

class AppData {
  AppData._();
  static final AppData instance = AppData._();

  String nomeAluno = '';
  String matricula = '';
  String curso = '';
  String status = 'ATIVO';
  String foto = 'assets/images/profile_placeholder.png';
  bool isCotista = false;
  double saldo = 0.0;
  List<Transacao> transacoes = [];

  // --- LISTA DE NOTIFICAÇÕES (Simulando o Banco de Dados) ---
  List<Notificacao> notificacoes = [];

  static const String matriculaRenan = '202520401811';
  static const String matriculaMaria = '12345';

  bool realizarLogin(String matriculaDigitada) {
    if (matriculaDigitada == matriculaRenan) {
      nomeAluno = 'Renan Souza do Nascimento';
      matricula = matriculaRenan;
      curso = 'Ciência da Computação';
      isCotista = false;
      saldo = 15.50;
      transacoes = [
        Transacao(descricao: 'Recarga Pix (App)', valor: 20.00, data: DateTime.now().subtract(const Duration(days: 1)), ehSaida: false, icone: Icons.pix),
      ];
      _carregarNotificacoesMock(); // Carrega as notificações ao logar
      return true;

    } else if (matriculaDigitada == matriculaMaria) {
      nomeAluno = 'Maria Silva (Bolsista)';
      matricula = matriculaMaria;
      curso = 'Direito';
      isCotista = true;
      saldo = 0.00;
      transacoes = [];
      _carregarNotificacoesMock();
      return true;
    }
    return false;
  }

  // Popula o app com dados baseados na comunicação real da UERJ
  void _carregarNotificacoesMock() {
    notificacoes = [
      Notificacao(
          titulo: 'Cardápio do Bandejão',
          mensagem: 'Prato Principal: Estrogonofe de Frango. Opção Vegana: Grão de Bico com Legumes. Sobremesa: Maçã.',
          data: DateTime.now().subtract(const Duration(hours: 2)),
          icone: Icons.restaurant,
          corIcone: Colors.orange
      ),
      Notificacao(
          titulo: 'Calendário Acadêmico',
          mensagem: 'Atenção: O prazo para solicitação de trancamento de disciplinas encerra nesta sexta-feira.',
          data: DateTime.now().subtract(const Duration(days: 1)),
          icone: Icons.calendar_month,
          corIcone: const Color(0xFF0072CE) // Azul UERJ
      ),
      Notificacao(
          titulo: 'Recarga Confirmada',
          mensagem: 'Sua recarga via Pix de R\$ 20,00 foi creditada com sucesso na sua carteirinha.',
          data: DateTime.now().subtract(const Duration(days: 2)),
          lida: true, // Essa já foi lida (não fica em negrito)
          icone: Icons.check_circle,
          corIcone: Colors.green
      ),
    ];
  }

  // Retorna a quantidade de alertas não lidos para o "bolinha vermelha"
  int get qtdNotificacoesNaoLidas => notificacoes.where((n) => !n.lida).length;

  void marcarTodasComoLidas() {
    for (var n in notificacoes) {
      n.lida = true;
    }
  }

  void registrarPagamento() {
    if (!isCotista) {
      saldo -= 2.00;
      transacoes.insert(0, Transacao(descricao: 'Refeição - Bandejão (Simulação)', valor: 2.00, data: DateTime.now(), ehSaida: true, icone: Icons.contactless));
    } else {
      transacoes.insert(0, Transacao(descricao: 'Refeição - Bandejão (Bolsista)', valor: 0.00, data: DateTime.now(), ehSaida: true, icone: Icons.contactless));
    }
  }

  void registrarRecarga(double valor) {
    saldo += valor;
    transacoes.insert(0, Transacao(descricao: 'Recarga Pix (App)', valor: valor, data: DateTime.now(), ehSaida: false, icone: Icons.pix));

    // Adiciona uma notificação real-time quando recarrega!
    notificacoes.insert(0, Notificacao(
        titulo: 'Nova Recarga',
        mensagem: 'Você adicionou R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')} à sua conta.',
        data: DateTime.now(),
        icone: Icons.account_balance_wallet,
        corIcone: Colors.green
    ));
  }
}