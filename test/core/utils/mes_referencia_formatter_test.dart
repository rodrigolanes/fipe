import 'package:flutter_test/flutter_test.dart';
import 'package:fipe/core/utils/mes_referencia_formatter.dart';

void main() {
  group('formatarMesReferencia', () {
    test('deve formatar mês de janeiro corretamente', () {
      expect(formatarMesReferencia('202601'), 'Janeiro/2026');
    });

    test('deve formatar mês de dezembro corretamente', () {
      expect(formatarMesReferencia('202512'), 'Dezembro/2025');
    });

    test('deve formatar mês de março corretamente', () {
      expect(formatarMesReferencia('202403'), 'Março/2024');
    });

    test('deve formatar todos os meses do ano', () {
      expect(formatarMesReferencia('202401'), 'Janeiro/2024');
      expect(formatarMesReferencia('202402'), 'Fevereiro/2024');
      expect(formatarMesReferencia('202403'), 'Março/2024');
      expect(formatarMesReferencia('202404'), 'Abril/2024');
      expect(formatarMesReferencia('202405'), 'Maio/2024');
      expect(formatarMesReferencia('202406'), 'Junho/2024');
      expect(formatarMesReferencia('202407'), 'Julho/2024');
      expect(formatarMesReferencia('202408'), 'Agosto/2024');
      expect(formatarMesReferencia('202409'), 'Setembro/2024');
      expect(formatarMesReferencia('202410'), 'Outubro/2024');
      expect(formatarMesReferencia('202411'), 'Novembro/2024');
      expect(formatarMesReferencia('202412'), 'Dezembro/2024');
    });

    test('deve retornar "Desconhecido" quando string vazia', () {
      expect(formatarMesReferencia(''), 'Desconhecido');
    });

    test('deve retornar original quando formato inválido (não numérico)', () {
      expect(formatarMesReferencia('abc123'), 'abc123');
    });

    test('deve retornar original quando tamanho incorreto', () {
      expect(formatarMesReferencia('2024'), '2024');
      expect(formatarMesReferencia('20240101'), '20240101');
    });

    test('deve retornar original quando mês inválido (> 12)', () {
      expect(formatarMesReferencia('202413'), '202413');
    });

    test('deve retornar original quando mês inválido (< 1)', () {
      expect(formatarMesReferencia('202400'), '202400');
    });

    test('deve retornar original quando já está formatado com barra', () {
      expect(formatarMesReferencia('Janeiro/2024'), 'Janeiro/2024');
    });

    test('deve retornar original quando já está formatado com "de"', () {
      expect(formatarMesReferencia('Janeiro de 2024'), 'Janeiro de 2024');
    });
  });

  group('MesReferenciaFormatter extension', () {
    test('deve formatar usando extensão', () {
      expect('202601'.formatado(), 'Janeiro/2026');
    });

    test('deve funcionar com todos os meses usando extensão', () {
      expect('202401'.formatado(), 'Janeiro/2024');
      expect('202406'.formatado(), 'Junho/2024');
      expect('202412'.formatado(), 'Dezembro/2024');
    });

    test('deve retornar "Desconhecido" para string vazia com extensão', () {
      expect(''.formatado(), 'Desconhecido');
    });

    test('deve retornar original para formato inválido com extensão', () {
      expect('abc'.formatado(), 'abc');
    });
  });
}
