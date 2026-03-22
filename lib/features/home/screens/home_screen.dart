import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';
import '../../id_card/screens/id_card_screen.dart';
import '../../payment/screens/pagar_screen.dart';
import '../../payment/screens/recarga_screen.dart';
import 'extrato_screen.dart';
import 'notificacoes_screen.dart';
import '../../login/screens/login_screen.dart';
import 'grade_horarios_screen.dart';
import 'meus_dados_screen.dart';

// Mudamos para StatefulWidget para o sininho atualizar quando lermos os avisos
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Função que abre a tela de notificações e, quando voltar, atualiza o sininho
  void _abrirNotificacoes() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificacoesScreen()));
    setState(() {}); // Atualiza a Home para sumir com a bolinha vermelha
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, VoidCallback? onTap, Color corBotao) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(color: corBotao, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: corBotao.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white), const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int qtdNaoLidas = AppData.instance.qtdNotificacoesNaoLidas;

    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Acesso Rápido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          // --- O ÍCONE DO SININHO ---
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: _abrirNotificacoes,
              ),
              // Se tiver notificação nova, desenha a bolinha vermelha
              if (qtdNaoLidas > 0)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: AppColors.vermelhoUerj, borderRadius: BorderRadius.circular(10)),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$qtdNaoLidas',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.azulUerj),
              accountName: Text(AppData.instance.nomeAluno, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              accountEmail: Text('Matrícula: ${AppData.instance.matricula}'),
              currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, backgroundImage: AppData.instance.provedorFoto),
            ),

            ListTile(
                leading: const Icon(Icons.person, color: AppColors.textoSecundario),
                title: const Text('Meus Dados', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context); // Fecha a gaveta
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MeusDadosScreen())); // Abre a tela
                }
            ),
            ListTile(
                leading: const Icon(Icons.calendar_month, color: AppColors.textoSecundario),
                title: const Text('Grade de Horários', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context); // Fecha a gaveta
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GradeHorariosScreen())); // Abre a tela
                }
            ),
            ListTile(leading: const Icon(Icons.settings, color: AppColors.textoSecundario), title: const Text('Configurações', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.bold)), onTap: () { Navigator.pop(context); }),
            const Divider(height: 30, thickness: 1),
            ListTile(leading: const Icon(Icons.exit_to_app, color: AppColors.vermelhoUerj), title: const Text('Sair do Aplicativo', style: TextStyle(color: AppColors.vermelhoUerj, fontWeight: FontWeight.bold)), onTap: () { Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false); }),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.0,
                children: [
                  _buildMenuButton(context, 'Pagar\nRestaurante', Icons.qr_code_scanner, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PagarScreen())), AppColors.vermelhoUerj),
                  _buildMenuButton(context, 'Carteirinha\nDigital', Icons.badge, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IdCardScreen())), AppColors.azulUerj),
                  _buildMenuButton(context, 'Saldo e\nExtrato', Icons.account_balance_wallet, () async { await Navigator.push(context, MaterialPageRoute(builder: (context) => const ExtratoScreen())); setState(() {}); }, AppColors.douradoUerj),
                  _buildMenuButton(context, 'Recarga\nvia Pix', Icons.pix, () async { await Navigator.push(context, MaterialPageRoute(builder: (context) => const RecargaScreen())); setState(() {}); }, Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/uerj_logo.png', height: 70, errorBuilder: (context, error, stackTrace) => const Column(children: [Icon(Icons.account_balance, size: 50, color: AppColors.azulUerj), Text('UERJ', style: TextStyle(color: AppColors.azulUerj, fontWeight: FontWeight.bold, fontSize: 18))])),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}