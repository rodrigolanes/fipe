import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'features/consulta_fipe/data/datasources/fipe_local_data_source.dart';
import 'features/consulta_fipe/data/datasources/fipe_local_data_source_sqlite_impl.dart';
import 'features/consulta_fipe/data/datasources/fipe_remote_data_source.dart';
import 'features/consulta_fipe/data/datasources/fipe_remote_data_source_impl.dart';
import 'features/consulta_fipe/data/repositories/fipe_repository_impl.dart';
import 'features/consulta_fipe/domain/repositories/fipe_repository.dart';
import 'features/consulta_fipe/domain/usecases/get_anos_combustiveis_por_modelo_usecase.dart';
import 'features/consulta_fipe/domain/usecases/get_anos_por_marca_usecase.dart';
import 'features/consulta_fipe/domain/usecases/get_marcas_por_tipo_usecase.dart';
import 'features/consulta_fipe/domain/usecases/get_modelos_por_marca_usecase.dart';
import 'features/consulta_fipe/domain/usecases/get_valor_fipe_usecase.dart';
import 'features/consulta_fipe/presentation/bloc/ano_combustivel_bloc.dart';
import 'features/consulta_fipe/presentation/bloc/marca_bloc.dart';
import 'features/consulta_fipe/presentation/bloc/modelo_bloc.dart';
import 'features/consulta_fipe/presentation/bloc/valor_fipe_bloc.dart';

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
  sl.registerFactory(() => MarcaBloc(getMarcasPorTipo: sl()));
  sl.registerFactory(() => ModeloBloc(getModelosPorMarca: sl()));
  sl.registerFactory(
    () => AnoCombustivelBloc(
      getAnosCombustiveisPorModelo: sl(),
      getAnosPorMarca: sl(),
    ),
  );
  sl.registerFactory(() => ValorFipeBloc(getValorFipe: sl()));

  // ! UseCases - Lazy Singleton
  sl.registerLazySingleton(() => GetMarcasPorTipoUseCase(sl()));
  sl.registerLazySingleton(() => GetModelosPorMarcaUseCase(sl()));
  sl.registerLazySingleton(() => GetAnosCombustiveisPorModeloUseCase(sl()));
  sl.registerLazySingleton(() => GetAnosPorMarcaUseCase(sl()));
  sl.registerLazySingleton(() => GetValorFipeUseCase(sl()));

  // ! Repositories - Lazy Singleton
  sl.registerLazySingleton<FipeRepository>(
    () => FipeRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ! DataSources - Lazy Singleton
  sl.registerLazySingleton<FipeRemoteDataSource>(
    () => FipeRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<FipeLocalDataSource>(
    () => FipeLocalDataSourceSqliteImpl(),
  );
}
