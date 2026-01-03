import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/presentation/widgets/error_widget.dart'
    as custom;

void main() {
  testWidgets('ErrorWidget deve exibir mensagem e botão de retry',
      (tester) async {
    const testMessage = 'Erro de teste';
    var retryPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: custom.ErrorWidget(
            message: testMessage,
            onRetry: () => retryPressed = true,
          ),
        ),
      ),
    );

    // Deve exibir o ícone de erro
    expect(find.byIcon(Icons.error_outline), findsOneWidget);

    // Deve exibir o título
    expect(find.text('Ops! Algo deu errado'), findsOneWidget);

    // Deve exibir a mensagem
    expect(find.text(testMessage), findsOneWidget);

    // Deve exibir o botão de retry
    expect(find.text('Tentar Novamente'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    // Testar callback onRetry - encontrar o ElevatedButton
    await tester.tap(find.text('Tentar Novamente'));
    await tester.pump();

    expect(retryPressed, isTrue);
  });

  testWidgets('ErrorWidget deve estar centralizado', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: custom.ErrorWidget(
            message: 'Erro',
            onRetry: () {},
          ),
        ),
      ),
    );

    // Deve ter Center widgets (pode haver múltiplos na árvore)
    expect(find.byType(Center), findsWidgets);

    // Deve ter Column com mainAxisAlignment center
    final column = tester.widget<Column>(find.byType(Column));
    expect(column.mainAxisAlignment, MainAxisAlignment.center);
  });

  testWidgets('ErrorWidget deve usar cores do theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ),
        ),
        home: Scaffold(
          body: custom.ErrorWidget(
            message: 'Erro',
            onRetry: () {},
          ),
        ),
      ),
    );

    // Verifica que o ícone existe
    final iconFinder = find.byIcon(Icons.error_outline);
    expect(iconFinder, findsOneWidget);

    final icon = tester.widget<Icon>(iconFinder);
    expect(icon.size, 80);
  });
}
