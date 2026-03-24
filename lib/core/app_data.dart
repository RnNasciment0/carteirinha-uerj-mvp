import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class Transacao {
  final String descricao;
  final double valor;
  final DateTime data;
  final bool ehSaida;
  final IconData icone;

  Transacao({required this.descricao, required this.valor, required this.data, required this.ehSaida, required this.icone});

  Map<String, dynamic> toJson() => {
    'descricao': descricao,
    'valor': valor,
    'data': data.toIso8601String(),
    'ehSaida': ehSaida,
    'icone_code': icone.codePoint,
  };

  factory Transacao.fromJson(Map<String, dynamic> json) => Transacao(
    descricao: json['descricao'],
    valor: json['valor'],
    data: DateTime.parse(json['data']),
    ehSaida: json['ehSaida'],
    icone: IconData(json['icone_code'], fontFamily: 'MaterialIcons'),
  );
}

class Notificacao {
  final String titulo;
  final String mensagem;
  final DateTime data;
  bool lida;
  final IconData icone;
  final Color corIcone;

  Notificacao({required this.titulo, required this.mensagem, required this.data, this.lida = false, required this.icone, required this.corIcone});

  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'mensagem': mensagem,
    'data': data.toIso8601String(),
    'lida': lida,
    'icone_code': icone.codePoint,
    'corIcone_value': corIcone.value,
  };

  factory Notificacao.fromJson(Map<String, dynamic> json) => Notificacao(
    titulo: json['titulo'],
    mensagem: json['mensagem'],
    data: DateTime.parse(json['data']),
    lida: json['lida'],
    icone: IconData(json['icone_code'], fontFamily: 'MaterialIcons'),
    corIcone: Color(json['corIcone_value']),
  );
}

class AppData {
  AppData._();
  static final AppData instance = AppData._();

  SharedPreferences? _prefs;

  // CHAVES BASE
  static const String keySaldo = 'uerj_saldo';
  static const String keyTransacoes = 'uerj_transacoes';
  static const String keyNotificacoes = 'uerj_notificacoes';
  static const String keyFoto = 'uerj_foto_perfil';
  static const String keyUltimaMatricula = 'uerj_ultima_matricula'; // --- NOVA CHAVE ---

  String nomeAluno = '';
  String matricula = '';
  String curso = '';
  String status = 'ATIVO';
  String foto = 'assets/images/profile_placeholder.png';
  String? caminhoFotoCustomizada;
  bool isCotista = false;

  String? ultimaMatriculaLogada; // --- MEMÓRIA DE QUEM USOU O APP POR ÚLTIMO ---

  double saldo = 0.0;
  List<Transacao> transacoes = [];
  List<Notificacao> notificacoes = [];

  static const String matriculaRenan = '202520401811';
  static const String matriculaMaria = '12345';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Assim que o app abre (antes de desenhar a tela), ele lembra de quem foi o último a entrar
    ultimaMatriculaLogada = _prefs!.getString(keyUltimaMatricula);
  }

  // Função interna para gravar a matrícula no disco
  Future<void> _registrarUltimoAcesso(String matriculaLogada) async {
    ultimaMatriculaLogada = matriculaLogada;
    if (_prefs != null) {
      await _prefs!.setString(keyUltimaMatricula, matriculaLogada);
    }
  }

  bool realizarLogin(String matriculaDigitada) {
    caminhoFotoCustomizada = null;

    if (matriculaDigitada == matriculaRenan) {
      nomeAluno = 'Renan Souza do Nascimento';
      matricula = matriculaRenan;
      curso = 'Ciência da Computação';
      isCotista = false;

      _carregarDadosPersistidos(15.50);
      _registrarUltimoAcesso(matriculaRenan); // --- SALVA O ACESSO DO RENAN ---
      return true;

    } else if (matriculaDigitada == matriculaMaria) {
      nomeAluno = 'Maria Silva (Bolsista)';
      matricula = matriculaMaria;
      curso = 'Direito';
      isCotista = true;

      _carregarDadosPersistidos(0.00);
      _registrarUltimoAcesso(matriculaMaria); // --- SALVA O ACESSO DA MARIA ---
      return true;
    }
    return false;
  }

  void _carregarDadosPersistidos(double saldoInicialMock) {
    if (_prefs == null) return;

    caminhoFotoCustomizada = _prefs!.getString('${keyFoto}_$matricula');
    saldo = _prefs!.getDouble('${keySaldo}_$matricula') ?? saldoInicialMock;

    String? transacoesJson = _prefs!.getString('${keyTransacoes}_$matricula');
    if (transacoesJson != null) {
      List<dynamic> listRaw = jsonDecode(transacoesJson);
      transacoes = listRaw.map((item) => Transacao.fromJson(item)).toList();
    } else {
      transacoes = [];
    }

    String? notificacoesJson = _prefs!.getString('${keyNotificacoes}_$matricula');
    if (notificacoesJson != null) {
      List<dynamic> listRaw = jsonDecode(notificacoesJson);
      notificacoes = listRaw.map((item) => Notificacao.fromJson(item)).toList();
    } else {
      _carregarNotificacoesPadrao();
      _salvarDadosNoDisco();
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
      await _prefs!.setString('${keyFoto}_$matricula', caminhoFotoCustomizada!);
    } else {
      await _prefs!.remove('${keyFoto}_$matricula');
    }

    await _prefs!.setDouble('${keySaldo}_$matricula', saldo);

    List<Map<String, dynamic>> transacoesMap = transacoes.map((t) => t.toJson()).toList();
    await _prefs!.setString('${keyTransacoes}_$matricula', jsonEncode(transacoesMap));

    List<Map<String, dynamic>> notificacoesMap = notificacoes.map((n) => n.toJson()).toList();
    await _prefs!.setString('${keyNotificacoes}_$matricula', jsonEncode(notificacoesMap));
  }

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

  int get qtdNotificacoesNaoLidas => notificacoes.where((n) => !n.lida).length;

  void marcarTodasComoLidas() {
    for (var n in notificacoes) { n.lida = true; }
    _salvarDadosNoDisco();
  }

  void registrarPagamento() {
    if (!isCotista) {
      saldo -= 2.00;
      transacoes.insert(0, Transacao(descricao: 'Refeição - Bandejão (Simulação)', valor: 2.00, data: DateTime.now(), ehSaida: true, icone: Icons.contactless));
      _salvarDadosNoDisco();
    } else {
      transacoes.insert(0, Transacao(descricao: 'Refeição - Bandejão (Bolsista)', valor: 0.00, data: DateTime.now(), ehSaida: true, icone: Icons.contactless));
      _salvarDadosNoDisco();
    }
  }

  void registrarRecarga(double valor) {
    saldo += valor;
    transacoes.insert(0, Transacao(descricao: 'Recarga Pix (App)', valor: valor, data: DateTime.now(), ehSaida: false, icone: Icons.pix));
    notificacoes.insert(0, Notificacao(titulo: 'Nova Recarga', mensagem: 'Você adicionou R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')} à sua conta.', data: DateTime.now(), icone: Icons.account_balance_wallet, corIcone: Colors.green));

    _salvarDadosNoDisco();
  }
}