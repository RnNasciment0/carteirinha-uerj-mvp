import 'package:flutter/material.dart';
// Importamos o pacote de código de barras
import 'package:barcode_widget/barcode_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_user.dart';

class IdCardScreen extends StatelessWidget {
  const IdCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Carteirinha Digital UERJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: 520,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: const BoxDecoration(
                    color: AppColors.azulUerj,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: const Text(
                    'UNIVERSIDADE DO ESTADO DO RIO DE JANEIRO',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                  ),
                ),
                const SizedBox(height: 25),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Container(
                      width: 100,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: AppColors.douradoUerj, width: 3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          simularEstudante.foto,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            simularEstudante.name,
                            style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textoPrimario,
                                height: 1.1
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Matrícula: ${simularEstudante.ID}',
                            style: const TextStyle(color: AppColors.textoSecundario, fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Curso: ${simularEstudante.curso}',
                            style: const TextStyle(color: AppColors.textoSecundario, fontSize: 14),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.green[600],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              simularEstudante.status,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                          'Acesso à Biblioteca / Carteirinha',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textoPrimario,
                              fontSize: 16
                          )
                      ),
                      const SizedBox(height: 15),

                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: simularEstudante.ID,
                        width: 280,
                        height: 70,
                        color: AppColors.textoPrimario,
                        drawText: true,
                        style: const TextStyle(color: AppColors.textoPrimario, fontWeight: FontWeight.bold),
                        errorBuilder: (context, error) => const Center(child: Text("Erro ao gerar")),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}