/// Utilitário para formatar tempo relativo (tempo decorrido).
///
/// Converte timestamps em strings legíveis como "há 5 minutos", "há 2 horas".
library;

/// Formata uma data em tempo relativo ao momento atual.
///
/// Exemplos:
/// - Menos de 1 minuto: "agora mesmo"
/// - 1-59 minutos: "há X minutos"
/// - 1-23 horas: "há X horas"
/// - 1 dia: "há 1 dia"
/// - 2-30 dias: "há X dias"
/// - Mais de 30 dias: "há mais de 30 dias"
String formatarTempoDecorrido(DateTime timestamp) {
  final agora = DateTime.now();
  final diferenca = agora.difference(timestamp);

  if (diferenca.inSeconds < 60) {
    return 'agora mesmo';
  } else if (diferenca.inMinutes < 60) {
    final minutos = diferenca.inMinutes;
    return minutos == 1 ? 'há 1 minuto' : 'há $minutos minutos';
  } else if (diferenca.inHours < 24) {
    final horas = diferenca.inHours;
    return horas == 1 ? 'há 1 hora' : 'há $horas horas';
  } else if (diferenca.inDays < 30) {
    final dias = diferenca.inDays;
    return dias == 1 ? 'há 1 dia' : 'há $dias dias';
  } else {
    return 'há mais de 30 dias';
  }
}

/// Extension para facilitar uso direto em DateTime.
///
/// Exemplo de uso:
/// ```dart
/// final timestamp = DateTime.now().subtract(Duration(minutes: 15));
/// print(timestamp.tempoDecorrido()); // "há 15 minutos"
/// ```
extension TimeAgoFormatter on DateTime {
  /// Formata a data em tempo relativo ao momento atual.
  String tempoDecorrido() => formatarTempoDecorrido(this);
}
