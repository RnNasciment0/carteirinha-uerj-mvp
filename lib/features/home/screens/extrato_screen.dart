import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pacote para formatar datas (já vem no Flutter)
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart'; // Nosso cérebro central

class ExtratoScreen extends StatelessWidget {
  const ExtratoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pega os dados atuais do AppData
    double saldoAtual = AppData.instance.saldo;
    List<Transacao> transacoes = AppData.instance.transacoes;
    DateFormat formatadorData = DateFormat('dd/MM, HH:mm'); // Formatador de data

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
          // --- CARTÃO DE SALDO NO TOPO (Estilo UERJ vibrante) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: AppColors.azulUerj,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Text('Seu Saldo Atual', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 10),
                Text(
                  'R\$ ${saldoAtual.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
                ),
                if (AppData.instance.isCotista)
                  const Text('(Acesso Gratuito Ativo)', style: TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.history, color: AppColors.textoSecundario),
                SizedBox(width: 10),
                Text('Últimas Movimentações', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textoSecundario)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // --- LISTA HISTÓRICA DO EXTRATO ---
          Expanded(
            child: transacoes.isEmpty
                ? const Center(child: Text('Nenhuma movimentação recente.'))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: transacoes.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey), // Linha divisória
              itemBuilder: (context, index) {
                final item = transacoes[index];

                // Define a cor e o sinal (+ ou -) baseado no tipo
                Color corValor = item.ehSaida ? AppColors.vermelhoUerj : Colors.green;
                String sinal = item.ehSaida ? '-' : '+';

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.azulUerj.withOpacity(0.05), shape: BoxShape.circle),
                    child: Icon(item.icone, color: AppColors.azulUerj, size: 25),
                  ),
                  title: Text(item.descricao, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrimario, fontSize: 15)),
                  subtitle: Text(formatadorData.format(item.data), style: const TextStyle(color: AppColors.textoSecundario, fontSize: 13)),
                  trailing: Text(
                    '$sinal R\$ ${item.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: corValor),
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