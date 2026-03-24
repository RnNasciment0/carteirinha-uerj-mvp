import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';

class ExtratoScreen extends StatefulWidget {
  const ExtratoScreen({super.key});

  @override
  State<ExtratoScreen> createState() => _ExtratoScreenState();
}

class _ExtratoScreenState extends State<ExtratoScreen> {
  // --- VARIÁVEL DO MODO PRIVACIDADE ---
  bool _mostrarSaldo = true;

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final transacoes = AppData.instance.transacoes;

    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Saldo e Extrato', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- CABEÇALHO DO SALDO (COM PRIVACIDADE) ---
          Container(
            width: double.infinity,
            color: AppColors.azulUerj,
            padding: const EdgeInsets.only(bottom: 30, top: 20),
            child: Column(
              children: [
                const Text('Saldo Disponível', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lógica para mostrar o valor real ou os pontinhos
                    Text(
                      _mostrarSaldo
                          ? 'R\$ ${AppData.instance.saldo.toStringAsFixed(2).replaceAll('.', ',')}'
                          : 'R\$ •••••',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    // Botão do Olhinho
                    IconButton(
                      icon: Icon(
                        _mostrarSaldo ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarSaldo = !_mostrarSaldo; // Inverte o estado
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),

          // --- TÍTULO DO HISTÓRICO ---
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.history, color: AppColors.textoSecundario),
                SizedBox(width: 10),
                Text('Histórico de Transações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textoPrimario)),
              ],
            ),
          ),

          // --- LISTA DE TRANSAÇÕES OU ESTADO VAZIO (EMPTY STATE) ---
          Expanded(
            child: transacoes.isEmpty
                ? // SE A LISTA FOR VAZIA, MOSTRA ESTE BLOCO BONITO
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Nenhuma transação encontrada', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textoSecundario)),
                  const SizedBox(height: 8),
                  const Text('O seu histórico de recargas e\npagamentos aparecerá aqui.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : // SE TIVER DADOS, DESENHA A LISTA NORMALMENTE
            ListView.builder(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                final transacao = transacoes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.withOpacity(0.2))),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: transacao.ehSaida ? AppColors.vermelhoUerj.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                      child: Icon(transacao.icone, color: transacao.ehSaida ? AppColors.vermelhoUerj : Colors.green),
                    ),
                    title: Text(transacao.descricao, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrimario)),
                    subtitle: Text(_formatarData(transacao.data), style: const TextStyle(color: AppColors.textoSecundario, fontSize: 12)),
                    trailing: Text(
                      '${transacao.ehSaida ? '-' : '+'} R\$ ${transacao.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: transacao.ehSaida ? AppColors.vermelhoUerj : Colors.green),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}