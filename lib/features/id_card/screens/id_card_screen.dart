import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_user.dart';

// Mudamos para StatefulWidget porque a tela agora tem "estado" (o cronômetro mudando)
class IdCardScreen extends StatefulWidget {
  const IdCardScreen({super.key});

  @override
  State<IdCardScreen> createState() => _IdCardScreenState();
}

class _IdCardScreenState extends State<IdCardScreen> {
  int tempoRestante = 30;
  late Timer _timer;
  String dadosQrCode = "";

  @override
  void initState() {
    super.initState();
    _gerarNovoQrCode();
    _iniciarTimer();
  }

  // Função para criar a lógica do cronômetro
  void _iniciarTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (tempoRestante > 0) {
          tempoRestante--;
        } else {
          tempoRestante = 30;
          _gerarNovoQrCode(); // Atualiza o QR Code quando zera
        }
      });
    });
  }

  // Função que simula o dado criptografado que a catraca vai ler
  void _gerarNovoQrCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    // O QR Code vai conter a matrícula + um código de tempo único
    dadosQrCode = "${simularEstudante.ID}_$timestamp";
  }

  // É muito importante cancelar o timer quando sair da tela para não gastar bateria
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Carteirinha Digital UERJ', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: 520, // Aumentei um pouquinho a altura para caber o QR Code real
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.azulUerj,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Text(
                    'UNIVERSIDADE DO ESTADO DO RIO DE JANEIRO',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      width: 100,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: AppColors.douradoUerj, width: 3),
                      ),
                      child: Image.asset(
                        simularEstudante.foto,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            simularEstudante.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textoPrimario),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Matrícula: ${simularEstudante.ID}',
                            style: const TextStyle(color: AppColors.textoSecundario),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Curso: ${simularEstudante.curso}',
                            style: const TextStyle(color: AppColors.textoSecundario),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green,
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
                    const SizedBox(width: 10),
                  ],
                ),
                const Spacer(),

                // --- NOVA ÁREA DO QR CODE FUNCIONAL ---
                Column(
                  children: [
                    const Text(
                        'Código de Acesso (Bandejão / Catraca)',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrimario)
                    ),
                    const SizedBox(height: 10),

                    // O Widget que gera o QR Code real
                    QrImageView(
                      data: dadosQrCode, // O dado que vai dentro do QR Code
                      version: QrVersions.auto,
                      size: 130.0,
                      foregroundColor: AppColors.textoPrimario,
                    ),

                    const SizedBox(height: 5),

                    // O texto que reage ao timer
                    Text(
                        'Atualiza em: ${tempoRestante}s',
                        style: TextStyle(
                          // Muda de cor quando está acabando o tempo
                            color: tempoRestante <= 5 ? Colors.red : Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}