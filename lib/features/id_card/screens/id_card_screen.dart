import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_user.dart';

class IdCardScreen extends StatefulWidget {
  const IdCardScreen({super.key});

  @override
  State<IdCardScreen> createState() => _IdCardScreenState();
}

class _IdCardScreenState extends State<IdCardScreen> {

  bool _mostrarFrente = true;

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

          child: GestureDetector(
            onTap: () {
              setState(() {
                _mostrarFrente = !_mostrarFrente;
              });
            },

            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _mostrarFrente ? 0 : math.pi),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutBack,
              builder: (context, double angulo, child) {

                bool mostrarConteudoVerso = angulo >= math.pi / 2;

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angulo),
                  alignment: Alignment.center,
                  child: mostrarConteudoVerso
                      ? _buildCartaoVerso(angulo)
                      : _buildCartaoFrente(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartaoFrente() {
    return Container(
      width: double.infinity,
      height: 520,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 7)),
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
                width: 100, height: 130,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: AppColors.douradoUerj, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(simularEstudante.foto, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(simularEstudante.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.textoPrimario, height: 1.1),
                    ),
                    const SizedBox(height: 10),
                    Text('Matrícula: ${simularEstudante.ID}', style: const TextStyle(color: AppColors.textoSecundario, fontSize: 14),),
                    const SizedBox(height: 5),
                    Text('Curso: ${simularEstudante.curso}', style: const TextStyle(color: AppColors.textoSecundario, fontSize: 14),),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(color: Colors.green[600], borderRadius: BorderRadius.circular(20),),
                      child: Text(simularEstudante.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
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
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),),
            child: Column(
              children: [
                const Text('Acesso à Biblioteca / Carteirinha', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrimario, fontSize: 16)),
                const SizedBox(height: 15),
                BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: simularEstudante.ID,
                  width: 280, height: 70,
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
    );
  }

  Widget _buildCartaoVerso(double angulo) {
    return Transform(
      transform: Matrix4.identity()..rotateY(math.pi),
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        height: 520,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 7)),
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
                'DADOS PESSOAIS / VALIDADE',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  _buildDadoLinha('Nasc.:', '15/05/2000'),
                  _buildDadoLinha('RG:', '12.345.678-9'),
                  _buildDadoLinha('CPF:', '123.456.789-00'),
                  const Divider(height: 40, color: AppColors.douradoUerj, thickness: 1,),
                  _buildDadoLinha('Emissão:', '10/01/2024'),
                  _buildDadoLinha('Validade:', '31/12/2026', ehDestaque: true),
                ],
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Text(
                      'Toque no cartão para voltar',
                      style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 14)
                  ),
                  const SizedBox(height: 10,),
                  const Icon(Icons.account_balance, color: AppColors.azulUerj, size: 40,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDadoLinha(String label, String valor, {bool ehDestaque = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoSecundario, fontSize: 16)),
          Text(
              valor,
              style: TextStyle(
                  fontWeight: ehDestaque ? FontWeight.bold : FontWeight.normal,
                  color: ehDestaque ? AppColors.vermelhoUerj : AppColors.textoPrimario,
                  fontSize: 16
              )
          ),
        ],
      ),
    );
  }
}