import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/presentation/widgets/modelo_item_widget.dart';
import '../../../../fixtures/modelo_fixture.dart';

void main() {
  testWidgets('ModeloItemWidget deve renderizar informações do modelo',
      (tester) async {
    final modelo = ModeloFixture.modeloEntity;
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModeloItemWidget(
            modelo: modelo,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    // Deve exibir o nome do modelo
    expect(find.text('PALIO 1.0'), findsOneWidget);

    // Deve ter Card e InkWell
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);

    // Deve ter ícone de carro
    expect(find.byIcon(Icons.directions_car), findsOneWidget);

    // Deve ter ícone de navegação
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    // Deve ter texto de ajuda
    expect(find.text('Toque para ver anos disponíveis'), findsOneWidget);
  });

  testWidgets('ModeloItemWidget deve chamar onTap quando clicado',
      (tester) async {
    final modelo = ModeloFixture.modeloEntity;
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModeloItemWidget(
            modelo: modelo,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('ModeloItemWidget deve ter ícone de informação', (tester) async {
    final modelo = ModeloFixture.modeloEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModeloItemWidget(
            modelo: modelo,
            onTap: () {},
          ),
        ),
      ),
    );

    // Deve ter ícone de info
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });

  testWidgets('ModeloItemWidget deve ter maxLines e overflow configurados',
      (tester) async {
    final modelo = ModeloFixture.modeloEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModeloItemWidget(
            modelo: modelo,
            onTap: () {},
          ),
        ),
      ),
    );

    // Deve encontrar o texto
    final textWidget = tester.widget<Text>(find.text(modelo.nome));

    // Deve ter maxLines 2 e overflow ellipsis
    expect(textWidget.maxLines, 2);
    expect(textWidget.overflow, TextOverflow.ellipsis);
  });

  testWidgets('ModeloItemWidget deve ter elevação no Card', (tester) async {
    final modelo = ModeloFixture.modeloEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModeloItemWidget(
            modelo: modelo,
            onTap: () {},
          ),
        ),
      ),
    );

    final card = tester.widget<Card>(find.byType(Card));
    expect(card.elevation, 2);
  });

  testWidgets('ModeloItemWidget deve ter bordas arredondadas', (tester) async {
    final modelo = ModeloFixture.modeloEntity;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModeloItemWidget(
            modelo: modelo,
            onTap: () {},
          ),
        ),
      ),
    );

    final card = tester.widget<Card>(find.byType(Card));
    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(12));
  });

  testWidgets('ModeloItemWidget deve usar cores do theme', (tester) async {
    final modelo = ModeloFixture.modeloEntity;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        home: Scaffold(
          body: ModeloItemWidget(
            modelo: modelo,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verificar que os containers existem
    expect(find.byType(Container), findsWidgets);
  });
}
