import 'package:flutter/material.dart';

import '../../features/consulta_fipe/presentation/pages/ano_combustivel_page.dart';
import '../../features/consulta_fipe/presentation/pages/home_page.dart';
import '../../features/consulta_fipe/presentation/pages/marca_list_page.dart';
import '../../features/consulta_fipe/presentation/pages/modelo_list_page.dart';
import '../../features/consulta_fipe/presentation/pages/splash_screen.dart';
import '../../features/consulta_fipe/presentation/pages/valor_detalhes_page.dart';

/// Configuração de rotas da aplicação
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String marcas = '/marcas';
  static const String modelos = '/modelos';
  static const String anosCombustiveis = '/anos-combustiveis';
  static const String valorDetalhes = '/valor-detalhes';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case marcas:
        final tipo = settings.arguments;
        if (tipo != null) {
          return MaterialPageRoute(
            builder: (_) => MarcaListPage(tipo: tipo as dynamic),
          );
        }
        return _errorRoute();

      case modelos:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => ModeloListPage(
              marcaId: args['marcaId'] as int,
              tipo: args['tipo'],
            ),
          );
        }
        return _errorRoute();

      case anosCombustiveis:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => AnoCombustivelPage(
              marcaId: args['marcaId'] as int,
              modeloId: args['modeloId'] as int,
              tipo: args['tipo'],
            ),
          );
        }
        return _errorRoute();

      case valorDetalhes:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (_) => ValorDetalhesPage(
              marcaId: args['marcaId'] as int,
              modeloId: args['modeloId'] as int,
              ano: args['ano'] as String,
              combustivel: args['combustivel'] as String,
              tipo: args['tipo'],
            ),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Página não encontrada')),
      ),
    );
  }
}
