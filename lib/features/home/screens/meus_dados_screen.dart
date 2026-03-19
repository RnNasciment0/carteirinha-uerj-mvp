import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';

class MeusDadosScreen extends StatelessWidget {
  const MeusDadosScreen({super.key});

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.azulUerj.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.azulUerj, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textoSecundario, fontSize: 13)),
                const SizedBox(height: 3),
                Text(value, style: const TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Meus Dados', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edição desabilitada no perfil acadêmico.'))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho com Foto
            Container(
              width: double.infinity,
              color: AppColors.azulUerj,
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(radius: 56, backgroundImage: AssetImage(AppData.instance.foto)),
                  ),
                  const SizedBox(height: 15),
                  Text(AppData.instance.nomeAluno, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.greenAccent)),
                    child: Text(AppData.instance.status, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),

            // Informações
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.badge, 'Matrícula', AppData.instance.matricula),
                    const Divider(height: 1),
                    _buildInfoRow(Icons.school, 'Curso', AppData.instance.curso),
                    const Divider(height: 1),
                    _buildInfoRow(Icons.email, 'E-mail Institucional', '${AppData.instance.matricula}@alu.uerj.br'),
                    const Divider(height: 1),
                    _buildInfoRow(Icons.phone, 'Telefone', '(21) 99999-9999'),
                    const Divider(height: 1),
                    _buildInfoRow(Icons.verified_user, 'Tipo de Acesso', AppData.instance.isCotista ? 'Bolsista/Cotista (Subsidiado)' : 'Ampla Concorrência'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}