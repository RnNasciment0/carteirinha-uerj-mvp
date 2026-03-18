import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
// Importamos o cérebro do app para pegar os dados do usuário logado
import '../../../core/app_data.dart';
import '../../id_card/screens/id_card_screen.dart';
import '../../payment/screens/pagar_screen.dart';
import 'extrato_screen.dart';
// Importamos a tela de login para podermos fazer o Logout
import '../../login/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, VoidCallback? onTap, Color corBotao) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
            color: corBotao,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: corBotao.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Acesso Rápido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      // --- O NOVO MENU LATERAL (DRAWER) ---
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero, // Tira a margem padrão para o cabeçalho encostar no topo
          children: [
            // Cabeçalho nativo do Flutter para perfis de usuário
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.azulUerj, // Fundo azul UERJ
              ),
              accountName: Text(
                  AppData.instance.nomeAluno,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              accountEmail: Text('Matrícula: ${AppData.instance.matricula}'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                // Puxa a foto dinâmica (sua ou do outro perfil)
                backgroundImage: AssetImage(AppData.instance.foto),
              ),
            ),

            // Itens do Menu (Por enquanto são visuais para o MVP)
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.textoSecundario),
              title: const Text('Meus Dados', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context); // Fecha a gaveta lateral
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Em breve: Edição de Perfil')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: AppColors.textoSecundario),
              title: const Text('Grade de Horários', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Em breve: Integração com o Aluno Online')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.textoSecundario),
              title: const Text('Configurações', style: TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(height: 30, thickness: 1), // Linha divisória

            // --- BOTÃO DE SAIR (LOGOUT) ---
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: AppColors.vermelhoUerj),
              title: const Text('Sair do Aplicativo', style: TextStyle(color: AppColors.vermelhoUerj, fontWeight: FontWeight.bold)),
              onTap: () {
                // A melhor prática para Logout no Flutter:
                // Remove todo o histórico de navegação (para não dar para voltar com a seta do celular)
                // E joga o usuário de volta para a tela de Login.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),

      // O resto do corpo da tela (Os botões e a logo) continua igual!
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.0,
                children: [
                  _buildMenuButton(
                      context, 'Pagar\nRestaurante', Icons.qr_code_scanner,
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PagarScreen())),
                      AppColors.vermelhoUerj
                  ),
                  _buildMenuButton(
                      context, 'Carteirinha\nDigital', Icons.badge,
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IdCardScreen())),
                      AppColors.azulUerj
                  ),
                  _buildMenuButton(
                      context, 'Saldo e\nExtrato', Icons.account_balance_wallet,
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ExtratoScreen())),
                      AppColors.douradoUerj
                  ),
                  _buildMenuButton(
                      context, 'Recarga\n(em breve)', Icons.pix, null, Colors.grey.shade400
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/uerj_logo.png', height: 70,
              errorBuilder: (context, error, stackTrace) => const Column(children: [Icon(Icons.account_balance, size: 50, color: AppColors.azulUerj), Text('UERJ', style: TextStyle(color: AppColors.azulUerj, fontWeight: FontWeight.bold, fontSize: 18))]),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}