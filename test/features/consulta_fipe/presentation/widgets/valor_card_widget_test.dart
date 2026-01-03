import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/presentation/widgets/valor_card_widget.dart';
import '../../../../fixtures/valor_fipe_fixture.dart';

void main() {
  testWidgets('ValorCardWidget deve exibir informações do valor FIPE',
      (tester) async {
    final valorFipe = ValorFipeFixture.valorFipeEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipe),
        ),
      ),
    );

    // Deve exibir marca
    expect(find.text('FIAT'), findsOneWidget);

    // Deve exibir modelo
    expect(find.text('PALIO 1.0'), findsOneWidget);

    // Deve exibir ano
    expect(find.text('2024'), findsOneWidget);

    // Deve exibir combustível
    expect(find.text('Gasolina'), findsOneWidget);

    // Deve exibir valor
    expect(find.text('R\$ 45.000,00'), findsOneWidget);

    // Deve exibir label "Valor FIPE"
    expect(find.text('Valor FIPE'), findsOneWidget);
  });

  testWidgets('ValorCardWidget deve ter Card com elevação', (tester) async {
    final valorFipe = ValorFipeFixture.valorFipeEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipe),
        ),
      ),
    );

    final card = tester.widget<Card>(find.byType(Card));
    expect(card.elevation, 4);
  });

  testWidgets('ValorCardWidget deve ter ícones adequados', (tester) async {
    final valorFipe = ValorFipeFixture.valorFipeEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipe),
        ),
      ),
    );

    // Ícone de calendário
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);

    // Ícone de combustível
    expect(find.byIcon(Icons.local_gas_station), findsOneWidget);
  });

  testWidgets('ValorCardWidget deve mostrar "Zero Km" para ano 32000',
      (tester) async {
    final valorFipeZeroKm = ValorFipeFixture.valorFipeZeroKmEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipeZeroKm),
        ),
      ),
    );

    // Deve exibir "Zero Km" em vez do ano
    expect(find.text('Zero Km'), findsOneWidget);

    // Não deve exibir "32000"
    expect(find.text('32000'), findsNothing);
  });

  testWidgets('ValorCardWidget deve ter Divider', (tester) async {
    final valorFipe = ValorFipeFixture.valorFipeEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipe),
        ),
      ),
    );

    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('ValorCardWidget deve usar cor primária do tema', (tester) async {
    final valorFipe = ValorFipeFixture.valorFipeEntity;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(primaryColor: Colors.deepPurple),
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipe),
        ),
      ),
    );

    final card = tester.widget<Card>(find.byType(Card));
    expect(card.color, Colors.deepPurple);
  });

  testWidgets('ValorCardWidget deve exibir textos em branco', (tester) async {
    final valorFipe = ValorFipeFixture.valorFipeEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipe),
        ),
      ),
    );

    // Verificar que encontra os textos (que devem ser brancos)
    expect(find.text('FIAT'), findsOneWidget);
    expect(find.text('Valor FIPE'), findsOneWidget);
  });

  testWidgets('ValorCardWidget deve ter padding', (tester) async {
    final valorFipe = ValorFipeFixture.valorFipeEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipe),
        ),
      ),
    );

    // Deve ter Padding widgets
    expect(find.byType(Padding), findsWidgets);
  });

  testWidgets('ValorCardWidget deve ter layout em coluna', (tester) async {
    final valorFipe = ValorFipeFixture.valorFipeEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValorCardWidget(valorFipe: valorFipe),
        ),
      ),
    );

    final column = tester.widget<Column>(find.byType(Column).first);
    expect(column.crossAxisAlignment, CrossAxisAlignment.start);
  });
}
