import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/sync_bloc.dart';

/// Tela de Splash com animação e verificação de atualizações
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkForUpdatesAndNavigate();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  Future<void> _checkForUpdatesAndNavigate() async {
    // Aguarda animação inicial
    await Future.delayed(
      const Duration(milliseconds: AppConstants.splashDelay),
    );

    if (!mounted) return;

    // Obtém o SyncBloc (Singleton)
    final syncBloc = di.sl<SyncBloc>();

    // Verifica se há atualizações
    syncBloc.add(const CheckForUpdatesEvent());

    // Aguarda resultado da verificação
    await for (final state in syncBloc.stream) {
      if (state is UpdateAvailable) {
        // Mostra diálogo perguntando se deseja atualizar
        if (mounted) {
          final shouldUpdate = await _showUpdateDialog(
            currentVersion: state.currentVersion,
            newVersion: state.newVersion,
          );

          if (shouldUpdate == true) {
            // Inicia sincronização
            if (mounted) {
              await _showSyncDialog(syncBloc);
            }
          }
        }
        break;
      } else if (state is NoUpdateAvailable || state is SyncError) {
        // Continua para home
        break;
      }
    }

    // SyncBloc é singleton, não fechamos aqui (continua rodando na HomePage)

    // Navega para home
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<bool?> _showUpdateDialog({
    required String currentVersion,
    required String newVersion,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.update, color: Colors.blue),
            SizedBox(width: 12),
            Text('Atualização Disponível'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Uma nova versão da tabela FIPE está disponível!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Versão atual: $currentVersion',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Deseja baixar os dados atualizados agora?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Você pode navegar online enquanto o download acontece em segundo plano.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Depois'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Baixar Agora'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSyncDialog(SyncBloc syncBloc) async {
    // Mostra o dialog PRIMEIRO (UI responsiva imediatamente)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlocProvider<SyncBloc>.value(
        value: syncBloc,
        child: BlocConsumer<SyncBloc, SyncState>(
          listener: (context, state) {
            if (state is SyncCompleted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      '✅ Sincronização concluída! App pronto para uso offline.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            } else if (state is SyncError) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro na sincronização: ${state.message}'),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'OK',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            String message = 'Sincronizando...';
            if (state is Syncing) {
              message = state.progressMessage;
            }

            return AlertDialog(
              title: const Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 16),
                  Text('Sincronizando'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text(
                    'Você pode usar o app normalmente enquanto isso.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Continuar em Background'),
                ),
              ],
            );
          },
        ),
      ),
    );

    // Dispara o evento DEPOIS que o dialog estiver visível
    // Usa Future.microtask para executar na próxima microtask (após rebuild)
    Future.microtask(() => syncBloc.add(const StartSyncEvent()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/icons/icon.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Consulte o preço médio dos veículos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
