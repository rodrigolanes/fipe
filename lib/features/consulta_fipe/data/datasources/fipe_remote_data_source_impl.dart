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

  int _getTipoVeiculoCodigo(TipoVeiculo tipo) {
    switch (tipo) {
      case TipoVeiculo.carro:
        return 1;
      case TipoVeiculo.moto:
        return 2;
      case TipoVeiculo.caminhao:
        return 3;
    }
  }

  @override
  Future<List<MarcaModel>> getMarcasByTipo(TipoVeiculo tipo) async {
    try {
      final tipoVeiculoCodigo = _getTipoVeiculoCodigo(tipo);

      // Buscar marcas com estatísticas
      final response = await client.rpc(
        'get_marcas_com_estatisticas',
        params: {'p_tipo_veiculo': tipoVeiculoCodigo},
      );

      return (response as List)
          .map(
            (json) => MarcaModel.fromJson({
              'id': json['codigo'],
              'nome': json['nome'],
              'tipo': tipo.nome,
              'total_modelos': json['total_modelos'],
              'primeiro_ano': json['primeiro_ano'],
              'ultimo_ano': json['ultimo_ano'],
            }),
          )
          .toList();
    } catch (e) {
      throw ServerException('Erro ao buscar marcas: ${e.toString()}');
    }
  }

  @override
  Future<List<ModeloModel>> getModelosByMarca(
    int marcaId,
    TipoVeiculo tipo, {
    String? ano,
  }) async {
    try {
      if (ano != null) {
        // Buscar apenas modelos disponíveis no ano especificado
        final response = await client
            .from('modelos_anos')
            .select('''
              modelos!inner(
                codigo,
                nome,
                codigo_marca
              ),
              anos_combustivel!inner(
                ano
              )
            ''')
            .eq('codigo_marca', marcaId)
            .eq('anos_combustivel.ano', ano);

        // Remover duplicatas (mesmo modelo pode ter vários combustíveis)
        final modelosUnicos = <int, ModeloModel>{};

        for (var json in response as List) {
          final modelo = json['modelos'];
          final codigo = modelo['codigo'] as int;

          if (!modelosUnicos.containsKey(codigo)) {
            modelosUnicos[codigo] = ModeloModel.fromJson({
              'id': codigo,
              'nome': modelo['nome'],
              'marca_id': modelo['codigo_marca'],
              'tipo': tipo.nome,
            });
          }
        }

        // Ordenar por nome
        final modelos = modelosUnicos.values.toList()
          ..sort((a, b) => a.nome.compareTo(b.nome));

        return modelos;
      }

      // Buscar todos os modelos da marca (sem filtro de ano)
      final response = await client
          .from('modelos')
          .select('id, codigo, nome, codigo_marca')
          .eq('codigo_marca', marcaId)
          .order('nome', ascending: true);

      return (response as List)
          .map(
            (json) => ModeloModel.fromJson({
              'id': json['codigo'],
              'nome': json['nome'],
              'marca_id': json['codigo_marca'],
              'tipo': tipo.nome,
            }),
          )
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
          .select('''
            codigo_ano_combustivel,
            anos_combustivel!inner(
              ano,
              combustivel,
              codigo
            )
          ''')
          .eq('codigo_modelo', modeloId)
          .order('anos_combustivel(ano)', ascending: false);

      return (response as List).map((json) {
        final anoCombustivel = json['anos_combustivel'];
        return AnoCombustivelModel.fromJson({
          'ano': anoCombustivel['ano'],
          'combustivel': anoCombustivel['combustivel'],
          'codigo_fipe': anoCombustivel['codigo'],
        });
      }).toList();
    } catch (e) {
      throw ServerException(
        'Erro ao buscar anos/combustíveis: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<AnoCombustivelModel>> getAnosPorMarca(
    int marcaId,
    TipoVeiculo tipo,
  ) async {
    try {
      final response = await client
          .from('modelos_anos')
          .select('''
            codigo_ano_combustivel,
            anos_combustivel!inner(
              ano,
              combustivel,
              codigo
            )
          ''')
          .eq('codigo_marca', marcaId);

      // Remover duplicatas usando Set
      final anosUnicos = <String, AnoCombustivelModel>{};

      for (var json in response as List) {
        final anoCombustivel = json['anos_combustivel'];
        final codigo = anoCombustivel['codigo'] as String;

        if (!anosUnicos.containsKey(codigo)) {
          anosUnicos[codigo] = AnoCombustivelModel.fromJson({
            'ano': anoCombustivel['ano'],
            'combustivel': anoCombustivel['combustivel'],
            'codigo_fipe': codigo,
          });
        }
      }

      return anosUnicos.values.toList();
    } catch (e) {
      throw ServerException('Erro ao buscar anos por marca: ${e.toString()}');
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
          .eq('codigo_marca', marcaId)
          .eq('codigo_modelo', modeloId)
          .eq('ano_modelo', int.parse(ano))
          .order('data_consulta', ascending: false)
          .limit(1)
          .single();

      return ValorFipeModel.fromJson(response);
    } catch (e) {
      throw ServerException('Erro ao buscar valor FIPE: ${e.toString()}');
    }
  }
}
