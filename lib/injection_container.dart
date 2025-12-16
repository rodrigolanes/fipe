import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';

/// Service Locator global
final sl = GetIt.instance;

/// Inicializa todas as dependências da aplicação
///
/// Deve ser chamado no início do app (main.dart) antes de runApp()
Future<void> initDependencies() async {
  // =========================================================================
  // External Dependencies
  // =========================================================================

  // Supabase
  final supabase = await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  sl.registerSingleton<SupabaseClient>(supabase.client);

  // =========================================================================
  // Core
  // =========================================================================

  // TODO: Registrar dependências do core (NetworkInfo, etc.)

  // =========================================================================
  // Features - Consulta FIPE
  // =========================================================================

  // ! BLoCs/Cubits - Factory (nova instância a cada chamada)
  // sl.registerFactory(
  //   () => MarcaBloc(getMarcasPorTipo: sl()),
  // );

  // ! UseCases - Lazy Singleton
  // sl.registerLazySingleton(() => GetMarcasPorTipoUseCase(sl()));
  // sl.registerLazySingleton(() => GetModelosPorMarcaUseCase(sl()));

  // ! Repositories - Lazy Singleton
  // sl.registerLazySingleton<FipeRepository>(
  //   () => FipeRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //   ),
  // );

  // ! DataSources - Lazy Singleton
  // sl.registerLazySingleton<SupabaseDataSource>(
  //   () => SupabaseDataSourceImpl(client: sl()),
  // );
  // sl.registerLazySingleton<LocalDataSource>(
  //   () => LocalDataSourceImpl(),
  // );
}
