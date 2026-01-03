import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fipe/features/consulta_fipe/data/datasources/fipe_local_data_source.dart';
import 'package:fipe/features/consulta_fipe/data/datasources/fipe_remote_data_source.dart';
import 'package:fipe/features/consulta_fipe/domain/repositories/fipe_repository.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_anos_combustiveis_por_modelo_usecase.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_anos_por_marca_usecase.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_marcas_por_tipo_usecase.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_modelos_por_marca_usecase.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_valor_fipe_usecase.dart';

/// Gerador de mocks usando Mockito
///
/// Execute: dart run build_runner build --delete-conflicting-outputs
@GenerateMocks([
  // External dependencies
  SupabaseClient,
  SupabaseQueryBuilder,
  PostgrestFilterBuilder,
  PostgrestTransformBuilder,
  Box,
  SharedPreferences,

  // Data sources
  FipeRemoteDataSource,
  FipeLocalDataSource,

  // Repositories
  FipeRepository,

  // Use cases
  GetMarcasPorTipoUseCase,
  GetModelosPorMarcaUseCase,
  GetAnosCombustiveisPorModeloUseCase,
  GetAnosPorMarcaUseCase,
  GetValorFipeUseCase,
])
void main() {}
