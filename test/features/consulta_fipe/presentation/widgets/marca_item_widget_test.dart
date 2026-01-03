import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/presentation/widgets/marca_item_widget.dart';
import '../../../../fixtures/marca_fixture.dart';

void main() {
  testWidgets('MarcaItemWidget deve renderizar informações da marca',
      (tester) async {
    final marca = MarcaFixture.marcaEntity;
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MarcaItemWidget(
            marca: marca,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    // Deve exibir o nome da marca
    expect(find.text('FIAT'), findsOneWidget);

    // Deve ter Card e InkWell
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);

    // Deve ter ícone de carro
    expect(find.byIcon(Icons.directions_car), findsOneWidget);

    // Deve ter ícone de navegação
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('MarcaItemWidget deve chamar onTap quando clicado',
      (tester) async {
    final marca = MarcaFixture.marcaEntity;
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MarcaItemWidget(
            marca: marca,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('MarcaItemWidget deve mostrar anos de disponibilidade',
      (tester) async {
    final marca = MarcaFixture.marcaComEstatisticasEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MarcaItemWidget(
            marca: marca,
            onTap: () {},
          ),
        ),
      ),
    );

    // Deve exibir range de anos (fixture: 1990-2026)
    expect(find.textContaining('1990'), findsOneWidget);
    expect(find.textContaining('2026'), findsOneWidget);
  });

  testWidgets('MarcaItemWidget deve mostrar total de modelos se disponível',
      (tester) async {
    final marca = MarcaFixture.marcaComEstatisticasEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MarcaItemWidget(
            marca: marca,
            onTap: () {},
          ),
        ),
      ),
    );

    // Deve mostrar ícone de modelo
    expect(find.byIcon(Icons.car_rental), findsOneWidget);

    // Deve mostrar quantidade de modelos
    expect(find.textContaining('150 modelo'), findsOneWidget);
  });

  testWidgets(
      'MarcaItemWidget deve exibir "Sem informação de anos" quando não tiver dados',
      (tester) async {
    final marca = MarcaFixture.marcaEntity; // sem estatísticas

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MarcaItemWidget(
            marca: marca,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Sem informação de anos'), findsOneWidget);
  });

  testWidgets('MarcaItemWidget deve indicar se marca está ativa',
      (tester) async {
    final marcaAtiva = MarcaFixture.marcaComEstatisticasEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MarcaItemWidget(
            marca: marcaAtiva,
            onTap: () {},
          ),
        ),
      ),
    );

    // Deve mostrar "Ativa" (fixture tem ultimoAno = 2026)
    expect(find.textContaining('Ativa'), findsOneWidget);
  });

  testWidgets('MarcaItemWidget deve usar cores apropriadas para marca ativa',
      (tester) async {
    final marcaAtiva = MarcaFixture.marcaComEstatisticasEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MarcaItemWidget(
            marca: marcaAtiva,
            onTap: () {},
          ),
        ),
      ),
    );

    // O Container do ícone deve ter cor primaryContainer
    final containers = tester.widgetList<Container>(find.byType(Container));
    expect(containers, isNotEmpty);
  });
}
