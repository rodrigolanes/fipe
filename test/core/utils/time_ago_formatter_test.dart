import 'package:fipe/core/utils/time_ago_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatarTempoDecorrido', () {
    test('deve retornar "agora mesmo" para menos de 1 minuto', () {
      final timestamp = DateTime.now().subtract(const Duration(seconds: 30));
      expect(formatarTempoDecorrido(timestamp), equals('agora mesmo'));
    });

    test('deve retornar "há 1 minuto" para exatamente 1 minuto', () {
      final timestamp = DateTime.now().subtract(const Duration(minutes: 1));
      expect(formatarTempoDecorrido(timestamp), equals('há 1 minuto'));
    });

    test('deve retornar "há X minutos" para 2-59 minutos', () {
      final timestamp = DateTime.now().subtract(const Duration(minutes: 15));
      expect(formatarTempoDecorrido(timestamp), equals('há 15 minutos'));
    });

    test('deve retornar "há 1 hora" para exatamente 1 hora', () {
      final timestamp = DateTime.now().subtract(const Duration(hours: 1));
      expect(formatarTempoDecorrido(timestamp), equals('há 1 hora'));
    });

    test('deve retornar "há X horas" para 2-23 horas', () {
      final timestamp = DateTime.now().subtract(const Duration(hours: 3));
      expect(formatarTempoDecorrido(timestamp), equals('há 3 horas'));
    });

    test('deve retornar "há 1 dia" para exatamente 1 dia', () {
      final timestamp = DateTime.now().subtract(const Duration(days: 1));
      expect(formatarTempoDecorrido(timestamp), equals('há 1 dia'));
    });

    test('deve retornar "há X dias" para 2-29 dias', () {
      final timestamp = DateTime.now().subtract(const Duration(days: 7));
      expect(formatarTempoDecorrido(timestamp), equals('há 7 dias'));
    });

    test('deve retornar "há mais de 30 dias" para mais de 30 dias', () {
      final timestamp = DateTime.now().subtract(const Duration(days: 45));
      expect(
        formatarTempoDecorrido(timestamp),
        equals('há mais de 30 dias'),
      );
    });
  });

  group('TimeAgoFormatter extension', () {
    test('deve formatar corretamente usando extension', () {
      final timestamp = DateTime.now().subtract(const Duration(minutes: 5));
      expect(timestamp.tempoDecorrido(), equals('há 5 minutos'));
    });

    test('deve funcionar para timestamp recente', () {
      final timestamp = DateTime.now().subtract(const Duration(seconds: 10));
      expect(timestamp.tempoDecorrido(), equals('agora mesmo'));
    });

    test('deve funcionar para timestamp antigo', () {
      final timestamp = DateTime.now().subtract(const Duration(days: 100));
      expect(timestamp.tempoDecorrido(), equals('há mais de 30 dias'));
    });
  });
}
