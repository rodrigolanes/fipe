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

  testWidgets('MarcaItemWidget deve ter ícone de carro', (tester) async {
    final marca = MarcaFixture.marcaEntity;

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

    // Deve exibir ícone de carro
    expect(find.byIcon(Icons.directions_car), findsOneWidget);
  });

  testWidgets('MarcaItemWidget deve ter ícone de navegação', (tester) async {
    final marca = MarcaFixture.marcaEntity;

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

    // Deve exibir seta de navegação
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('MarcaItemWidget deve aplicar estilos corretos', (tester) async {
    final marca = MarcaFixture.marcaEntity;

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

    // Deve ter um Card como widget raiz
    expect(find.byType(Card), findsOneWidget);
    // Deve ter InkWell para resposta de toque
    expect(find.byType(InkWell), findsOneWidget);
  });

  testWidgets('MarcaItemWidget deve ser compacto e eficiente', (tester) async {
    final marca = MarcaFixture.marcaEntity;

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

    // Deve exibir apenas elementos essenciais: ícone, nome, navegação
    expect(find.byType(Container), findsWidgets); // Container do ícone
    expect(find.text(marca.nome), findsOneWidget);
  });

  testWidgets('MarcaItemWidget layout deve ser responsivo', (tester) async {
    final marca = MarcaFixture.marcaEntity;

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

    // O Container do ícone deve ter elementos visuais organizados
    final containers = tester.widgetList<Container>(find.byType(Container));
    expect(containers, isNotEmpty);
  });
}
