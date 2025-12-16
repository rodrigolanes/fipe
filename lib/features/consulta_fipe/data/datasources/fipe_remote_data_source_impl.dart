import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/ano_combustivel_model.dart';
import '../models/marca_model.dart';
import '../models/modelo_model.dart';
import '../models/valor_fipe_model.dart';
import 'fipe_remote_data_source.dart';

class FipeRemoteDataSourceImpl implements FipeRemoteDataSource {
  final SupabaseClient client;

  FipeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MarcaModel>> getMarcasByTipo(TipoVeiculo tipo) async {
    try {
      final response = await client
          .from('marcas')
          .select()
          .eq('tipo', tipo.nome)
          .order('nome');

      return (response as List)
          .map((json) => MarcaModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Erro ao buscar marcas: ${e.toString()}');
    }
  }

  @override
  Future<List<ModeloModel>> getModelosByMarca(
    int marcaId,
    TipoVeiculo tipo,
  ) async {
    try {
      final response = await client
          .from('modelos')
          .select()
          .eq('marca_id', marcaId)
          .eq('tipo', tipo.nome)
          .order('nome');

      return (response as List)
          .map((json) => ModeloModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Erro ao buscar modelos: ${e.toString()}');
    }
  }

  @override
  Future<List<AnoCombustivelModel>> getAnosCombustiveisByModelo(
    int modeloId,
    TipoVeiculo tipo,
  ) async {
    try {
      final response = await client
          .from('modelos_anos')
          .select('ano, combustivel, codigo_fipe')
          .eq('modelo_id', modeloId)
          .order('ano', ascending: false);

      return (response as List)
          .map(
            (json) =>
                AnoCombustivelModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw ServerException(
        'Erro ao buscar anos/combustíveis: ${e.toString()}',
      );
    }
  }

  @override
  Future<ValorFipeModel> getValorFipe({
    required int marcaId,
    required int modeloId,
    required String ano,
    required String combustivel,
    required TipoVeiculo tipo,
  }) async {
    try {
      final response = await client
          .from('valores_fipe')
          .select('''
            marca,
            modelo,
            ano_modelo,
            combustivel,
            codigo_fipe,
            mes_referencia,
            valor,
            data_consulta
          ''')
          .eq('marca_id', marcaId)
          .eq('modelo_id', modeloId)
          .eq('ano', ano)
          .eq('combustivel', combustivel)
          .order('data_consulta', ascending: false)
          .limit(1)
          .single();

      return ValorFipeModel.fromJson(response);
    } catch (e) {
      throw ServerException('Erro ao buscar valor FIPE: ${e.toString()}');
    }
  }
}
