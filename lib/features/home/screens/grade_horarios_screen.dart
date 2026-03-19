import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';

class GradeHorariosScreen extends StatelessWidget {
  const GradeHorariosScreen({super.key});

  // Função para gerar o horário dependendo do perfil que fez login
  List<Map<String, String>> _obterAulasDoDia(String dia, String curso) {
    if (curso == 'Ciência da Computação') {
      // Horário realista para Computação
      switch (dia) {
        case 'Seg': return [{'hora': '09:00 - 10:40', 'materia': 'Estrutura de Dados', 'local': 'Sala 4012 - Bloco F'}, {'hora': '11:00 - 12:40', 'materia': 'Cálculo II', 'local': 'Sala 3020 - Bloco A'}];
        case 'Ter': return [{'hora': '08:00 - 09:40', 'materia': 'Programação Orientada a Objetos (Java)', 'local': 'Lab 2 - Bloco E'}, {'hora': '10:00 - 11:40', 'materia': 'Física I', 'local': 'Sala 2011 - Bloco B'}];
        case 'Qua': return [{'hora': '09:00 - 10:40', 'materia': 'Estrutura de Dados', 'local': 'Sala 4012 - Bloco F'}];
        case 'Qui': return [{'hora': '08:00 - 11:40', 'materia': 'Linguagem de Programação (C++)', 'local': 'Lab 4 - Bloco E'}];
        case 'Sex': return [{'hora': '14:00 - 15:40', 'materia': 'Empreendedorismo e Inovação', 'local': 'Sala 6010 - Bloco F'}];
        default: return [];
      }
    } else {
      // Horário fictício para a Maria (Direito)
      switch (dia) {
        case 'Seg': return [{'hora': '08:00 - 09:40', 'materia': 'Direito Constitucional', 'local': 'Sala 7014 - Bloco D'}];
        case 'Qua': return [{'hora': '10:00 - 11:40', 'materia': 'Direito Penal I', 'local': 'Sala 7015 - Bloco D'}];
        case 'Sex': return [{'hora': '08:00 - 11:40', 'materia': 'Prática Jurídica', 'local': 'Núcleo de Práticas - Bloco F'}];
        default: return [];
      }
    }
  }

  Widget _buildDiaTab(String dia, String curso) {
    final aulas = _obterAulasDoDia(dia, curso);

    if (aulas.isEmpty) {
      return const Center(child: Text('Dia livre! Nenhuma aula agendada.', style: TextStyle(color: AppColors.textoSecundario, fontSize: 16)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: aulas.length,
      itemBuilder: (context, index) {
        final aula = aulas[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coluna do Horário
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.azulUerj.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      const Icon(Icons.access_time, color: AppColors.azulUerj, size: 20),
                      const SizedBox(height: 5),
                      Text(aula['hora']!.split(' - ')[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.azulUerj)),
                      const Text('|', style: TextStyle(color: AppColors.azulUerj)),
                      Text(aula['hora']!.split(' - ')[1], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.azulUerj)),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                // Coluna da Matéria e Local
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(aula['materia']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textoPrimario)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: AppColors.textoSecundario),
                          const SizedBox(width: 5),
                          Expanded(child: Text(aula['local']!, style: const TextStyle(color: AppColors.textoSecundario))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String curso = AppData.instance.curso;

    return DefaultTabController(
      length: 5, // Segunda a Sexta
      child: Scaffold(
        backgroundColor: AppColors.corFundo,
        appBar: AppBar(
          backgroundColor: AppColors.azulUerj,
          title: const Text('Grade de Horários', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppColors.douradoUerj,
            indicatorWeight: 4,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'SEG'),
              Tab(text: 'TER'),
              Tab(text: 'QUA'),
              Tab(text: 'QUI'),
              Tab(text: 'SEX'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDiaTab('Seg', curso),
            _buildDiaTab('Ter', curso),
            _buildDiaTab('Qua', curso),
            _buildDiaTab('Qui', curso),
            _buildDiaTab('Sex', curso),
          ],
        ),
      ),
    );
  }
}