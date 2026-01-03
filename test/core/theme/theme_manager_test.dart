import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fipe/core/theme/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeManager', () {
    test('deve inicializar com tema do sistema', () {
      final manager = ThemeManager();
      expect(manager.themeMode, ThemeMode.system);
    });

    test('deve alternar de system para light', () async {
      final manager = ThemeManager();
      await manager.toggleTheme();
      expect(manager.themeMode, ThemeMode.light);
    });

    test('deve alternar de light para dark', () async {
      final manager = ThemeManager();
      await manager.setThemeMode(ThemeMode.light);
      await manager.toggleTheme();
      expect(manager.themeMode, ThemeMode.dark);
    });

    test('deve alternar de dark para system', () async {
      final manager = ThemeManager();
      await manager.setThemeMode(ThemeMode.dark);
      await manager.toggleTheme();
      expect(manager.themeMode, ThemeMode.system);
    });

    test('deve retornar ícone correto para cada modo', () async {
      final manager = ThemeManager();

      await manager.setThemeMode(ThemeMode.system);
      expect(manager.themeIcon, Icons.brightness_auto);

      await manager.setThemeMode(ThemeMode.light);
      expect(manager.themeIcon, Icons.light_mode);

      await manager.setThemeMode(ThemeMode.dark);
      expect(manager.themeIcon, Icons.dark_mode);
    });

    test('deve retornar label correto para cada modo', () async {
      final manager = ThemeManager();

      await manager.setThemeMode(ThemeMode.system);
      expect(manager.themeLabel, 'Tema do Sistema');

      await manager.setThemeMode(ThemeMode.light);
      expect(manager.themeLabel, 'Tema Claro');

      await manager.setThemeMode(ThemeMode.dark);
      expect(manager.themeLabel, 'Tema Escuro');
    });

    test('deve persistir tema selecionado', () async {
      final manager1 = ThemeManager();
      await manager1.setThemeMode(ThemeMode.dark);

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('theme_mode');

      expect(saved, ThemeMode.dark.toString());
    });

    test('setThemeMode não deve notificar se modo for o mesmo', () async {
      final manager = ThemeManager();
      var notificationCount = 0;

      manager.addListener(() {
        notificationCount++;
      });

      await manager.setThemeMode(ThemeMode.system);
      await manager.setThemeMode(ThemeMode.system);

      // Apenas uma notificação da inicialização
      expect(notificationCount, lessThanOrEqualTo(1));
    });

    test('setThemeMode deve notificar quando modo muda', () async {
      final manager = ThemeManager();
      var notificationCount = 0;

      manager.addListener(() {
        notificationCount++;
      });

      await manager.setThemeMode(ThemeMode.light);
      await manager.setThemeMode(ThemeMode.dark);

      expect(notificationCount, greaterThanOrEqualTo(2));
    });

    test('toggleTheme deve notificar listeners', () async {
      final manager = ThemeManager();
      var notificationCount = 0;

      manager.addListener(() {
        notificationCount++;
      });

      await manager.toggleTheme();

      expect(notificationCount, greaterThan(0));
    });
  });
}
