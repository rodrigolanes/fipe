import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fipe/features/consulta_fipe/presentation/widgets/loading_widget.dart'
    as custom;

void main() {
  testWidgets('LoadingWidget deve renderizar shimmer effect', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: custom.LoadingWidget(),
        ),
      ),
    );

    // Deve encontrar um ListView
    expect(find.byType(ListView), findsOneWidget);

    // Deve encontrar múltiplos Shimmer widgets (10 itens)
    expect(find.byType(Shimmer), findsWidgets);

    // Deve encontrar Cards
    expect(find.byType(Card), findsWidgets);

    // Deve encontrar ListTiles
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('LoadingWidget deve ter múltiplos itens', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: custom.LoadingWidget(),
        ),
      ),
    );

    // Verifica que há múltiplos shimmer items (pelo menos 5)
    final shimmerWidgets = find.byType(Shimmer);
    expect(shimmerWidgets, findsAtLeastNWidgets(5));
  });

  testWidgets('LoadingWidget deve ter estrutura correta', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: custom.LoadingWidget(),
        ),
      ),
    );

    // Deve ter CircleAvatar (leading)
    expect(find.byType(CircleAvatar), findsWidgets);

    // Deve ter Container para título e trailing
    expect(find.byType(Container), findsWidgets);
  });
}
