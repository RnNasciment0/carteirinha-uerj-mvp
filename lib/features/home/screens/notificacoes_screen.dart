import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  @override
  void initState() {
    super.initState();
    // Assim que a tela abre, avisamos o "cérebro" para marcar tudo como lido
    Future.delayed(Duration.zero, () {
      setState(() {
        AppData.instance.marcarTodasComoLidas();
      });
    });
  }

  String _formatarData(DateTime data) {
    final hoje = DateTime.now();
    final diferenca = hoje.difference(data);

    if (diferenca.inDays == 0) return 'Hoje';
    if (diferenca.inDays == 1) return 'Ontem';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final notificacoes = AppData.instance.notificacoes;

    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Comunicações', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: notificacoes.isEmpty
          ? const Center(child: Text('Nenhuma notificação no momento.', style: TextStyle(color: AppColors.textoSecundario)))
          : ListView.separated(
        itemCount: notificacoes.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notif = notificacoes[index];

          return Container(
            // Fundo levemente azulado se não foi lida
            color: notif.lida ? Colors.transparent : AppColors.azulUerj.withOpacity(0.05),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: notif.corIcone.withOpacity(0.1),
                child: Icon(notif.icone, color: notif.corIcone),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notif.titulo,
                    style: TextStyle(
                        fontWeight: notif.lida ? FontWeight.normal : FontWeight.bold, // Negrito se nova
                        color: AppColors.textoPrimario,
                        fontSize: 16
                    ),
                  ),
                  Text(
                    _formatarData(notif.data),
                    style: TextStyle(color: AppColors.textoSecundario, fontSize: 12, fontWeight: notif.lida ? FontWeight.normal : FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  notif.mensagem,
                  style: const TextStyle(color: AppColors.textoSecundario, height: 1.3),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}