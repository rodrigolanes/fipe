import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/ads/ad_manager.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura orientação preferencial
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializa dependências
  await di.initDependencies();

  // Inicializa AdMob apenas em plataformas mobile (Android/iOS)
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    await AdManager.initialize();
  }

  runApp(FipeApp());
}

/// Aplicação FIPE
class FipeApp extends StatelessWidget {
  FipeApp({super.key});

  final ThemeManager _themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeManager,
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeManager.themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: (settings) {
            return AppRoutes.generateRoute(settings, _themeManager);
          },
        );
      },
    );
  }
}
