import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importação do pacote
import 'dart:convert'; // Importação nativa para lidar com JSON
import 'dart:io';

// --- MODELO: TRANSAÇÃO (Turbinado com JSON) ---
class Transacao {
  final String descricao;
  final double valor;
  final DateTime data;
  final bool ehSaida;
  final IconData icone;

  Transacao({required this.descricao, required this.valor, required this.data, required this.ehSaida, required this.icone});

  // TRANSFORMA O OBJETO EM TEXTO (JSON) PARA GRAVAR
  Map<String, dynamic> toJson() => {
    'descricao': descricao,
    'valor': valor,
    'data': data.toIso8601String(), // Grava data como texto formatado
    'ehSaida': ehSaida,
    'icone_code': icone.codePoint, // Grava o código do ícone
  };

  // TRANSFORMA O TEXTO (JSON) LIDO DO DISCO EM OBJETO DART
  factory Transacao.fromJson(Map<String, dynamic> json) => Transacao(
    descricao: json['descricao'],
    valor: json['valor'],
    data: DateTime.parse(json['data']), // Lê texto e transforma em Data
    ehSaida: json['ehSaida'],
    // Recria o ícone usando o código gravado (padrão Material Icons)
    icone: IconData(json['icone_code'], fontFamily: 'MaterialIcons'),
  );
}

// --- MODELO: NOTIFICAÇÃO (Turbinado com JSON) ---
class Notificacao {
  final String titulo;
  final String mensagem;
  final DateTime data;
  bool lida;
  final IconData icone;
  final Color corIcone;

  Notificacao({required this.titulo, required this.mensagem, required this.data, this.lida = false, required this.icone, required this.corIcone});

  // TRANSFORMA O OBJETO EM TEXTO (JSON) PARA GRAVAR
  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'mensagem': mensagem,
    'data': data.toIso8601String(),
    'lida': lida,
    'icone_code': icone.codePoint,
    'corIcone_value': corIcone.value, // Grava o valor numérico da cor
  };

  // TRANSFORMA O TEXTO (JSON) LIDO DO DISCO EM OBJETO DART
  factory Notificacao.fromJson(Map<String, dynamic> json) => Notificacao(
    titulo: json['titulo'],
    mensagem: json['mensagem'],
    data: DateTime.parse(json['data']),
    lida: json['lida'],
    icone: IconData(json['icone_code'], fontFamily: 'MaterialIcons'),
    corIcone: Color(json['corIcone_value']), // Recria a cor usando o valor numérico
  );
}

class AppData {
  ImageProvider get provedorFoto {
    if (caminhoFotoCustomizada != null && caminhoFotoCustomizada!.isNotEmpty) {
      return FileImage(File(caminhoFotoCustomizada!));
    }
    return AssetImage(foto);
  }

  void atualizarFoto(String novoCaminho) {
    caminhoFotoCustomizada = novoCaminho;
    _salvarDadosNoDisco();
  }
  AppData._();
  static final AppData instance = AppData._();

  SharedPreferences? _prefs;

  static const String keySaldo = 'uerj_saldo';
  static const String keyTransacoes = 'uerj_transacoes';
  static const String keyNotificacoes = 'uerj_notificacoes';
  static const String keyFoto = 'uerj_foto_perfil';

  String nomeAluno = '';
  String matricula = '';
  String curso = '';
  String status = 'ATIVO';
  String foto = 'assets/images/profile_placeholder.png';
  String? caminhoFotoCustomizada;
  bool isCotista = false;

  // Dados Dinâmicos (Que vamos salvar no disco!)
  double saldo = 0.0;
  List<Transacao> transacoes = [];
  List<Notificacao> notificacoes = [];

  static const String matriculaRenan = '202520401811';
  static const String matriculaMaria = '12345';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool realizarLogin(String matriculaDigitada) {
    if (matriculaDigitada == matriculaRenan) {
      nomeAluno = 'Renan Souza do Nascimento';
      matricula = matriculaRenan;
      curso = 'Ciência da Computação';
      isCotista = false;

      _carregarDadosPersistidos(15.50); // Tenta ler o saldo do disco, se não houver usa 15.50
      return true;

    } else if (matriculaDigitada == matriculaMaria) {
      nomeAluno = 'Maria Silva (Bolsista)';
      matricula = matriculaMaria;
      curso = 'Direito';
      isCotista = true;

      _carregarDadosPersistidos(0.00); // Tenta ler do disco, senão 0.00
      return true;
    }
    return false;
  }

  // --- FUNÇÃO DE CARREGAR DADOS DO DISCO ---
  void _carregarDadosPersistidos(double saldoInicialMock) {
    if (_prefs == null) return;

    saldo = _prefs!.getDouble(keySaldo) ?? saldoInicialMock;
    caminhoFotoCustomizada = _prefs!.getString(keyFoto);

    String? transacoesJson = _prefs!.getString(keyTransacoes);
    if (transacoesJson != null) {
      List<dynamic> listRaw = jsonDecode(transacoesJson);
      transacoes = listRaw.map((item) => Transacao.fromJson(item)).toList();
    } else {
      transacoes = [];
    }

    String? notificacoesJson = _prefs!.getString(keyNotificacoes);
    if (notificacoesJson != null) {
      List<dynamic> listRaw = jsonDecode(notificacoesJson);
      notificacoes = listRaw.map((item) => Notificacao.fromJson(item)).toList();
    } else {
      _carregarNotificacoesPadrao();
      _salvarDadosNoDisco(); // Já grava as padrão no disco
    }
  }

  void _carregarNotificacoesPadrao() {
    notificacoes = [
      Notificacao(titulo: 'Cardápio do Bandejão', mensagem: 'Prato Principal: Estrogonofe de Frango. Opção Vegana: Grão de Bico com Legumes.', data: DateTime.now().subtract(const Duration(hours: 2)), icone: Icons.restaurant, corIcone: Colors.orange),
      Notificacao(titulo: 'Calendário Acadêmico', mensagem: 'Atenção: O prazo para solicitação de trancamento de disciplinas encerra nesta sexta-feira.', data: DateTime.now().subtract(const Duration(days: 1)), icone: Icons.calendar_month, corIcone: const Color(0xFF0072CE)),
    ];
  }

  Future<void> _salvarDadosNoDisco() async {
    if (_prefs == null) return;

    if (caminhoFotoCustomizada != null) {
      await _prefs!.setString(keyFoto, caminhoFotoCustomizada!);
    }
    await _prefs!.setDouble(keySaldo, saldo);

    List<Map<String, dynamic>> transacoesMap = transacoes.map((t) => t.toJson()).toList();
    String transacoesJson = jsonEncode(transacoesMap);
    await _prefs!.setString(keyTransacoes, transacoesJson);

    List<Map<String, dynamic>> notificacoesMap = notificacoes.map((n) => n.toJson()).toList();
    String notificacoesJson = jsonEncode(notificacoesMap);
    await _prefs!.setString(keyNotificacoes, notificacoesJson);
  }

  int get qtdNotificacoesNaoLidas => notificacoes.where((n) => !n.lida).length;

  void marcarTodasComoLidas() {
    for (var n in notificacoes) { n.lida = true; }
    _salvarDadosNoDisco();
  }

  void registrarPagamento() {
    if (!isCotista) {
      saldo -= 2.00;
      transacoes.insert(0, Transacao(descricao: 'Refeição - Bandejão (Simulação)', valor: 2.00, data: DateTime.now(), ehSaida: true, icone: Icons.contactless));
      _salvarDadosNoDisco(); // Mudou saldo/histórico -> Grava no disco!
    } else {
      transacoes.insert(0, Transacao(descricao: 'Refeição - Bandejão (Bolsista)', valor: 0.00, data: DateTime.now(), ehSaida: true, icone: Icons.contactless));
      _salvarDadosNoDisco(); // Mudou histórico -> Grava no disco!
    }
  }

  void registrarRecarga(double valor) {
    saldo += valor;
    transacoes.insert(0, Transacao(descricao: 'Recarga Pix (App)', valor: valor, data: DateTime.now(), ehSaida: false, icone: Icons.pix));
    notificacoes.insert(0, Notificacao(titulo: 'Nova Recarga', mensagem: 'Você adicionou R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')} à sua conta.', data: DateTime.now(), icone: Icons.account_balance_wallet, corIcone: Colors.green));

    _salvarDadosNoDisco(); // Mudou tudo -> Grava no disco de uma vez!
  }
}