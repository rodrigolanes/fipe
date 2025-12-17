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

  /// Mapeia nome do combustível para código numérico
  /// 1=Gasolina, 2=Álcool/Etanol, 3=Diesel, 4=Elétrico, 5=Flex, 6=Híbrido, 7=Gás Natural
  int _getCombustivelCodigo(String combustivel) {
    final combustivelLower = combustivel.toLowerCase();
    if (combustivelLower.contains('gasolina')) return 1;
    if (combustivelLower.contains('álcool') || combustivelLower.contains('etanol')) return 2;
    if (combustivelLower.contains('diesel')) return 3;
    if (combustivelLower.contains('elétrico') || combustivelLower.contains('eletrico')) return 4;
    if (combustivelLower.contains('flex')) return 5;
    if (combustivelLower.contains('híbrido') || combustivelLower.contains('hibrido')) return 6;
    if (combustivelLower.contains('gás') || combustivelLower.contains('gnv')) return 7;
    return 1; // Default: Gasolina
  }

  @override
  Future<List<MarcaModel>> getMarcasByTipo(TipoVeiculo tipo) async {
    try {
      final tipoVeiculoCodigo = _getTipoVeiculoCodigo(tipo);

      print(
        '🔍 FipeRemoteDataSource: Buscando marcas para tipo $tipo (código: $tipoVeiculoCodigo)',
      );

      // Buscar marcas com estatísticas
      final response = await client.rpc(
        'get_marcas_com_estatisticas',
        params: {'p_tipo_veiculo': tipoVeiculoCodigo},
      );

      print(
        '✅ FipeRemoteDataSource: Resposta recebida: ${response.length} marcas',
      );

      return response
          .map<MarcaModel>(
            (json) => MarcaModel.fromJson({
              'id': int.parse(json['codigo'].toString()),
              'nome': json['nome'],
              'tipo': tipo.nome,
              'total_modelos': json['total_modelos'],
              'primeiro_ano': json['primeiro_ano'],
              'ultimo_ano': json['ultimo_ano'],
            }),
          )
          .toList();
    } catch (e) {
      print('❌ FipeRemoteDataSource: Erro ao buscar marcas: $e');
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
      print(
        '🔍 FipeRemoteDataSource: Buscando modelos para marca $marcaId (tipo: $tipo${ano != null ? ', ano: $ano' : ''})',
      );

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
            .eq('codigo_marca', marcaId.toString())
            .eq('anos_combustivel.ano', ano);

        print(
          '✅ FipeRemoteDataSource: Resposta recebida com ${response.length} registros',
        );

        // Remover duplicatas (mesmo modelo pode ter vários combustíveis)
        final modelosUnicos = <int, ModeloModel>{};

        for (var json in response) {
          final modelo = json['modelos'];
          final codigo = int.parse(modelo['codigo'].toString());

          if (!modelosUnicos.containsKey(codigo)) {
            modelosUnicos[codigo] = ModeloModel.fromJson({
              'id': codigo,
              'nome': modelo['nome'],
              'marca_id': int.parse(modelo['codigo_marca'].toString()),
              'tipo': tipo.nome,
            });
          }
        }

        // Ordenar por nome
        final modelos = modelosUnicos.values.toList()
          ..sort((a, b) => a.nome.compareTo(b.nome));

        print(
          '✅ FipeRemoteDataSource: ${modelos.length} modelos únicos encontrados',
        );
        return modelos;
      }

      // Buscar todos os modelos da marca (sem filtro de ano)
      final tipoVeiculoCodigo = _getTipoVeiculoCodigo(tipo);
      final response = await client
          .from('modelos')
          .select('codigo, nome, codigo_marca')
          .eq('codigo_marca', marcaId.toString())
          .eq('tipo_veiculo', tipoVeiculoCodigo)
          .order('nome', ascending: true);

      print(
        '✅ FipeRemoteDataSource: Resposta recebida: ${response.length} modelos',
      );

      return response
          .map<ModeloModel>(
            (json) => ModeloModel.fromJson({
              'id': int.parse(json['codigo'].toString()),
              'nome': json['nome'],
              'marca_id': int.parse(json['codigo_marca'].toString()),
              'tipo': tipo.nome,
            }),
          )
          .toList();
    } catch (e) {
      print('❌ FipeRemoteDataSource: Erro ao buscar modelos: $e');
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

      return response.map<AnoCombustivelModel>((json) {
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
          .eq('codigo_marca', marcaId.toString());

      // Remover duplicatas usando Set
      final anosUnicos = <String, AnoCombustivelModel>{};

      for (var json in response) {
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
      final tipoVeiculoCodigo = _getTipoVeiculoCodigo(tipo);
      final codigoCombustivel = _getCombustivelCodigo(combustivel);

      print(
        '🔍 FipeRemoteDataSource: Buscando valor FIPE - Marca: $marcaId, Modelo: $modeloId, Ano: $ano, Combustível: $combustivel (código: $codigoCombustivel), Tipo: $tipo',
      );

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
          .eq('codigo_marca', marcaId.toString())
          .eq('codigo_modelo', modeloId)
          .eq('tipo_veiculo', tipoVeiculoCodigo)
          .eq('ano_modelo', int.parse(ano))
          .eq('codigo_combustivel', codigoCombustivel)
          .order('data_consulta', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        print(
          '⚠️ FipeRemoteDataSource: Nenhum valor encontrado, pode ser necessário consultar API externa',
        );
        throw ServerException('Valor FIPE não encontrado para este veículo');
      }

      print(
        '✅ FipeRemoteDataSource: Valor FIPE encontrado: ${response['valor']}',
      );
      return ValorFipeModel.fromJson(response);
    } catch (e) {
      print('❌ FipeRemoteDataSource: Erro ao buscar valor FIPE: $e');
      throw ServerException('Erro ao buscar valor FIPE: ${e.toString()}');
    }
  }
}
