import '../../../../core/constants/app_constants.dart';
import '../models/ano_combustivel_model.dart';
import '../models/marca_model.dart';
import '../models/modelo_model.dart';
import '../models/valor_fipe_model.dart';

/// Interface para a fonte de dados remota (Supabase)
abstract class FipeRemoteDataSource {
  /// Busca marcas por tipo de veículo
  Future<List<MarcaModel>> getMarcasByTipo(TipoVeiculo tipo);

  /// Busca modelos por marca
  Future<List<ModeloModel>> getModelosByMarca(
    int marcaId,
    TipoVeiculo tipo, {
    String? ano,
  });

  /// Busca anos e combustíveis disponíveis para um modelo
  Future<List<AnoCombustivelModel>> getAnosCombustiveisByModelo(
    int modeloId,
    TipoVeiculo tipo,
  );

  /// Busca anos disponíveis para uma marca (todos os modelos)
  Future<List<AnoCombustivelModel>> getAnosPorMarca(
    int marcaId,
    TipoVeiculo tipo,
  );

  /// Busca o valor FIPE de um veículo específico
  Future<ValorFipeModel> getValorFipe({
    required int marcaId,
    required int modeloId,
    required String ano,
    required String combustivel,
    required TipoVeiculo tipo,
  });
}
