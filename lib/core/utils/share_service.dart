import 'package:share_plus/share_plus.dart';

import '../../features/consulta_fipe/domain/entities/valor_fipe_entity.dart';

/// Serviço para compartilhar informações de veículos e valores FIPE
class ShareService {
  /// Compartilha o valor FIPE de um veículo
  ///
  /// Formata uma mensagem amigável com as informações do veículo
  /// e permite compartilhar via WhatsApp, Telegram, etc.
  static Future<void> compartilharValorFipe(ValorFipeEntity valorFipe) async {
    final mensagem = _formatarMensagemValorFipe(valorFipe);

    try {
      await Share.share(
        mensagem,
        subject: 'Valor FIPE - ${valorFipe.modelo}',
      );
    } catch (e) {
      // Erro ao compartilhar - pode ser ignorado ou logado
      print('❌ Erro ao compartilhar: $e');
    }
  }

  /// Compartilha informações básicas de um veículo (sem valor)
  static Future<void> compartilharVeiculo({
    required String marca,
    required String modelo,
    required String ano,
    required String combustivel,
  }) async {
    final mensagem = '''
🚗 Veículo de Interesse

📌 Marca: $marca
📌 Modelo: $modelo
📌 Ano: $ano
⛽ Combustível: $combustivel

📱 Consulte mais preços no app FIPE!
''';

    try {
      await Share.share(
        mensagem,
        subject: 'Veículo - $marca $modelo',
      );
    } catch (e) {
      print('❌ Erro ao compartilhar: $e');
    }
  }

  /// Formata a mensagem com as informações do valor FIPE
  static String _formatarMensagemValorFipe(ValorFipeEntity valorFipe) {
    // Verifica se é Zero Km
    final isZeroKm = valorFipe.anoModelo == 32000;
    final anoFormatado = isZeroKm ? 'Zero Km' : valorFipe.anoModelo.toString();

    return '''
🚗 Tabela FIPE

📌 Veículo: ${valorFipe.marca} ${valorFipe.modelo}
📅 Ano: $anoFormatado
⛽ Combustível: ${valorFipe.combustivel}

💰 Valor FIPE: ${valorFipe.valor}
📊 Mês de referência: ${valorFipe.mesReferencia}
🔖 Código FIPE: ${valorFipe.codigoFipe}

📱 Consulte mais preços no app FIPE!
''';
  }

  /// Compartilha comparação entre veículos (feature futura)
  static Future<void> compartilharComparacao(
    List<ValorFipeEntity> veiculos,
  ) async {
    if (veiculos.isEmpty) return;

    final mensagem = _formatarMensagemComparacao(veiculos);

    try {
      await Share.share(
        mensagem,
        subject: 'Comparação FIPE - ${veiculos.length} veículos',
      );
    } catch (e) {
      print('❌ Erro ao compartilhar: $e');
    }
  }

  /// Formata mensagem de comparação entre veículos
  static String _formatarMensagemComparacao(
    List<ValorFipeEntity> veiculos,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('🚗 Comparação FIPE\n');

    for (var i = 0; i < veiculos.length; i++) {
      final veiculo = veiculos[i];
      final numero = i + 1;
      final isZeroKm = veiculo.anoModelo == 32000;
      final anoFormatado = isZeroKm ? 'Zero Km' : veiculo.anoModelo.toString();

      buffer.writeln('$numero. ${veiculo.marca} ${veiculo.modelo}');
      buffer.writeln('   Ano: $anoFormatado | ${veiculo.combustivel}');
      buffer.writeln('   💰 ${veiculo.valor}\n');
    }

    buffer.writeln('📊 Mês: ${veiculos.first.mesReferencia}');
    buffer.writeln('\n📱 Consulte mais preços no app FIPE!');

    return buffer.toString();
  }
}
