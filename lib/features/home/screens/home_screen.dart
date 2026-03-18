import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../id_card/screens/id_card_screen.dart';
import '../../payment/screens/pagar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Atualizamos o botão para aceitar cores diferentes e colocamos uma sombra legal
  Widget _buildMenuButton(BuildContext context, String title, IconData icon, VoidCallback? onTap, Color corBotao) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
            color: corBotao,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: corBotao.withOpacity(0.3), // Sombra da mesma cor do botão
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
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
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Os botões ocupam o espaço superior e central
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // Mantém os botões quadrados
                children: [
                  _buildMenuButton(
                      context,
                      'Pagar\nRestaurante',
                      Icons.qr_code_scanner,
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PagarScreen())),
                      AppColors.vermelhoUerj // Vermelho para destacar a ação de pagar
                  ),
                  _buildMenuButton(
                      context,
                      'Carteirinha\nDigital',
                      Icons.badge,
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IdCardScreen())),
                      AppColors.azulUerj // Azul UERJ para o documento oficial
                  ),
                  _buildMenuButton(
                      context,
                      'Saldo e\nExtrato',
                      Icons.account_balance_wallet,
                          () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Em breve'))),
                      AppColors.douradoUerj // Dourado remetendo a finanças/saldo
                  ),
                  _buildMenuButton(
                      context,
                      'Recarga\n(em breve)',
                      Icons.pix,
                      null,
                      Colors.grey.shade400 // Cinza para botão desativado
                  ),
                ],
              ),
            ),

            // --- LOGO DA UERJ NO RODAPÉ ---
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/uerj_logo.png', // Vai puxar a imagem que você salvou
              height: 70, // Tamanho ideal para não espremer os botões
              // O errorBuilder evita que o app quebre se você esquecer de colocar a imagem na pasta
              errorBuilder: (context, error, stackTrace) => const Column(
                children: [
                  Icon(Icons.account_balance, size: 50, color: AppColors.azulUerj),
                  Text('UERJ', style: TextStyle(color: AppColors.azulUerj, fontWeight: FontWeight.bold, fontSize: 18))
                ],
              ),
            ),
            const SizedBox(height: 10), // Um pequeno espaço no fundo
          ],
        ),
      ),
    );
  }
}