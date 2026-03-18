import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/app_data.dart';

class RecargaScreen extends StatefulWidget {
  const RecargaScreen({super.key});

  @override
  State<RecargaScreen> createState() => _RecargaScreenState();
}

class _RecargaScreenState extends State<RecargaScreen> {
  double _valorSelecionado = 20.00; // Começa com 20 pré-selecionado
  bool _pixGerado = false;
  bool _pagamentoConcluido = false;

  // Controlador para o campo de digitar o valor
  final TextEditingController _valorCustomizadoController = TextEditingController();

  @override
  void dispose() {
    _valorCustomizadoController.dispose();
    super.dispose();
  }

  void _simularPagamentoPix() {
    AppData.instance.registrarRecarga(_valorSelecionado);
    setState(() { _pagamentoConcluido = true; });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) { Navigator.pop(context); }
    });
  }

  // Widget de botão rápido (Atualizado)
  Widget _buildBotaoValor(double valor) {
    // Só fica azul se o valor for igual ao do botão E o campo de texto estiver vazio
    bool selecionado = _valorSelecionado == valor && _valorCustomizadoController.text.isEmpty;

    return InkWell(
      onTap: () {
        if (!_pixGerado) {
          setState(() {
            _valorSelecionado = valor;
            _valorCustomizadoController.clear(); // Limpa o que o usuário digitou
            FocusScope.of(context).unfocus(); // Fecha o teclado do celular
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.azulUerj : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selecionado ? AppColors.azulUerj : Colors.grey[400]!),
        ),
        child: Text(
          'R\$ ${valor.toStringAsFixed(0)}',
          style: TextStyle(
              color: selecionado ? Colors.white : AppColors.textoPrimario,
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCotista = AppData.instance.isCotista;

    return Scaffold(
      backgroundColor: AppColors.corFundo,
      appBar: AppBar(
        backgroundColor: AppColors.azulUerj,
        title: const Text('Recarga via Pix', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView( // Adicionado para a tela não dar erro quando o teclado subir
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))]),
            child: isCotista
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                const Text('Acesso Gratuito', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 15),
                const Text('Você é bolsista/cotista e possui acesso 100% subsidiado ao Restaurante Universitário. Não é necessário realizar recargas.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.textoSecundario, height: 1.5)),
                const SizedBox(height: 30),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.azulUerj), onPressed: () => Navigator.pop(context), child: const Text('Voltar', style: TextStyle(color: Colors.white)))
              ],
            )
                : AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: _pagamentoConcluido ? _buildTelaSucesso() : _buildFluxoRecarga()),
          ),
        ),
      ),
    );
  }

  Widget _buildFluxoRecarga() {
    return Column(
      key: const ValueKey('tela_recarga'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.pix, size: 50, color: Colors.teal),
        const SizedBox(height: 10),
        const Text('Adicionar Saldo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textoPrimario)),
        const SizedBox(height: 20),

        if (!_pixGerado) ...[
          const Text('Selecione um valor rápido:', style: TextStyle(color: AppColors.textoSecundario, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBotaoValor(10.0),
              _buildBotaoValor(20.0),
              _buildBotaoValor(50.0),
            ],
          ),

          const SizedBox(height: 25),
          const Text('Ou digite outro valor:', style: TextStyle(color: AppColors.textoSecundario, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // --- NOVO CAMPO DE TEXTO PARA VALOR PERSONALIZADO ---
          TextField(
            controller: _valorCustomizadoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixText: 'R\$ ', // Coloca o R$ fixo antes do que o usuário digita
              hintText: '0,00',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.azulUerj, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
            onChanged: (valorDigitado) {
              // Troca vírgula por ponto para o Dart conseguir converter em Decimal
              String valorLimpo = valorDigitado.replaceAll(',', '.');
              double? valorConvertido = double.tryParse(valorLimpo);

              setState(() {
                if (valorConvertido != null && valorConvertido > 0) {
                  _valorSelecionado = valorConvertido; // Atualiza a variável de cobrança
                } else {
                  _valorSelecionado = 0.0; // Se apagar tudo, zera o valor
                }
              });
            },
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.azulUerj, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              // O botão só funciona se o valor for maior que Zero
              onPressed: _valorSelecionado > 0 ? () {
                FocusScope.of(context).unfocus(); // Fecha o teclado
                setState(() { _pixGerado = true; });
              } : null, // Se for <= 0, o botão fica cinza e desativado
              child: const Text('GERAR CÓDIGO PIX', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ]
        else ...[
          Text('Valor: R\$ ${_valorSelecionado.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 15),
          QrImageView(data: "00020126580014BR.GOV.BCB.PIX0136123e4567-e89b-12d3-a456-426655440000", version: QrVersions.auto, size: 150.0),
          const SizedBox(height: 15),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.copy, size: 20, color: AppColors.textoSecundario), SizedBox(width: 8), Text('Copiar código Pix', style: TextStyle(color: AppColors.textoSecundario, fontWeight: FontWeight.bold))])),
          const SizedBox(height: 25),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(icon: const Icon(Icons.check_circle, color: Colors.white), label: const Text('SIMULAR PAGAMENTO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: _simularPagamentoPix)),
          const SizedBox(height: 10),
          TextButton(onPressed: () { setState(() { _pixGerado = false; }); }, child: const Text('Cancelar', style: TextStyle(color: Colors.red)))
        ],
      ],
    );
  }

  Widget _buildTelaSucesso() {
    return Column(
      key: const ValueKey('tela_sucesso'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle, size: 100, color: Colors.teal)),
        const SizedBox(height: 20),
        const Text('Recarga Concluída!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 10),
        Text('+ RS ${_valorSelecionado.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        const SizedBox(height: 20),
        const Text('Redirecionando...', style: TextStyle(color: AppColors.textoSecundario)),
        const SizedBox(height: 40),
      ],
    );
  }
}