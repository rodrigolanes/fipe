import 'package:fipe/features/consulta_fipe/presentation/widgets/data_freshness_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DataFreshnessIndicator', () {
    testWidgets('deve exibir indicador de cache laranja', (tester) async {
      final timestamp = DateTime.now().subtract(const Duration(minutes: 5));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataFreshnessIndicator(
              timestamp: timestamp,
              isFromCache: true,
            ),
          ),
        ),
      );

      // Verifica ícone de storage (cache)
      expect(find.byIcon(Icons.storage), findsOneWidget);

      // Verifica texto contendo "Cache"
      expect(find.textContaining('Cache'), findsOneWidget);

      // Verifica texto contendo tempo decorrido
      expect(find.textContaining('há'), findsOneWidget);
    });

    testWidgets('deve exibir indicador online verde', (tester) async {
      final timestamp = DateTime.now().subtract(const Duration(seconds: 5));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataFreshnessIndicator(
              timestamp: timestamp,
              isFromCache: false,
            ),
          ),
        ),
      );

      // Verifica ícone de nuvem (online)
      expect(find.byIcon(Icons.cloud_done), findsOneWidget);

      // Verifica texto contendo "Online"
      expect(find.textContaining('Online'), findsOneWidget);

      // Verifica texto "agora mesmo"
      expect(find.textContaining('agora mesmo'), findsOneWidget);
    });

    testWidgets('deve exibir tempo decorrido correto', (tester) async {
      final timestamp = DateTime.now().subtract(const Duration(hours: 2));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataFreshnessIndicator(
              timestamp: timestamp,
              isFromCache: true,
            ),
          ),
        ),
      );

      // Verifica que o tempo está correto
      expect(find.textContaining('há 2 horas'), findsOneWidget);
    });

    testWidgets('deve ter layout correto (ícone + texto)', (tester) async {
      final timestamp = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataFreshnessIndicator(
              timestamp: timestamp,
              isFromCache: false,
            ),
          ),
        ),
      );

      // Verifica que Container existe
      expect(find.byType(Container), findsWidgets);

      // Verifica que Row existe (layout horizontal)
      expect(find.byType(Row), findsOneWidget);

      // Verifica que Icon existe
      expect(find.byType(Icon), findsOneWidget);

      // Verifica que Text existe
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
