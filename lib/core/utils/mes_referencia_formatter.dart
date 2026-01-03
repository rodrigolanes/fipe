/// Utilitário para formatação de mês de referência FIPE.
///
/// Converte o formato YYYYMM (202601) para formato legível (Janeiro/2026).
library;

/// Formata mês de referência de YYYYMM para formato legível.
///
/// Exemplos:
/// - "202601" → "Janeiro/2026"
/// - "202512" → "Dezembro/2025"
/// - "202403" → "Março/2024"
///
/// Se o formato for inválido, retorna a string original.
String formatarMesReferencia(String mesReferencia) {
  if (mesReferencia.isEmpty) return 'Desconhecido';

  // Se já está em formato legível, retorna direto
  if (mesReferencia.contains('/') || mesReferencia.contains('de')) {
    return mesReferencia;
  }

  // Valida formato YYYYMM
  if (mesReferencia.length != 6 ||
      !RegExp(r'^\d{6}$').hasMatch(mesReferencia)) {
    return mesReferencia; // Retorna original se inválido
  }

  try {
    final ano = mesReferencia.substring(0, 4);
    final mesNum = int.parse(mesReferencia.substring(4, 6));

    if (mesNum < 1 || mesNum > 12) {
      return mesReferencia; // Mês inválido
    }

    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    final mesNome = meses[mesNum - 1];
    return '$mesNome/$ano';
  } catch (e) {
    return mesReferencia; // Em caso de erro, retorna original
  }
}

/// Extension para facilitar uso direto em strings.
///
/// Exemplo de uso:
/// ```dart
/// final mes = "202601";
/// print(mes.formatado()); // "Janeiro/2026"
/// ```
extension MesReferenciaFormatter on String {
  /// Formata o mês de referência para formato legível.
  String formatado() => formatarMesReferencia(this);
}
