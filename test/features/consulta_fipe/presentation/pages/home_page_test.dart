import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fipe/features/consulta_fipe/presentation/pages/home_page.dart';
import 'package:fipe/features/consulta_fipe/presentation/widgets/veiculo_type_card.dart';
import 'package:fipe/core/theme/theme_manager.dart';

class MockThemeManager extends Mock implements ThemeManager {}

void main() {
  late MockThemeManager mockThemeManager;

  setUp(() {
    mockThemeManager = MockThemeManager();
    when(() => mockThemeManager.themeIcon).thenReturn(Icons.dark_mode);
    when(() => mockThemeManager.themeLabel).thenReturn('Modo Escuro');
    when(() => mockThemeManager.toggleTheme()).thenAnswer((_) async => {});
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('HomePage deve ter AppBar com título correto', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    expect(find.text('FIPE Consulta'), findsOneWidget);
  });

  testWidgets('HomePage deve exibir botão de tema no AppBar', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });

  testWidgets('HomePage deve exibir título principal', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    expect(find.text('Selecione o tipo de veículo'), findsOneWidget);
  });

  testWidgets('HomePage deve exibir subtítulo', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    expect(
      find.text('Escolha o tipo de veículo que deseja consultar'),
      findsOneWidget,
    );
  });

  testWidgets('HomePage deve exibir cards de tipo de veículo', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    expect(find.byType(VeiculoTypeCard), findsWidgets);
  });

  testWidgets('HomePage deve exibir card de Carros', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    expect(find.text('Carros'), findsOneWidget);
    expect(find.byIcon(Icons.directions_car), findsOneWidget);
  });

  testWidgets('HomePage deve exibir card de Motos', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    expect(find.text('Motos'), findsOneWidget);
    expect(find.byIcon(Icons.two_wheeler), findsOneWidget);
  });

  testWidgets('HomePage deve usar GridView', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('HomePage deve chamar toggleTheme ao clicar no botão de tema',
      (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        HomePage(themeManager: mockThemeManager),
      ),
    );

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    verify(() => mockThemeManager.toggleTheme()).called(1);
  });
}
