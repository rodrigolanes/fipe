import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
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
    if (combustivelLower.contains('álcool') ||
        combustivelLower.contains('etanol')) {
      return 2;
    }
    if (combustivelLower.contains('diesel')) return 3;
    if (combustivelLower.contains('elétrico') ||
        combustivelLower.contains('eletrico')) {
      return 4;
    }
    if (combustivelLower.contains('flex')) return 5;
    if (combustivelLower.contains('híbrido') ||
        combustivelLower.contains('hibrido')) {
      return 6;
    }
    if (combustivelLower.contains('gás') || combustivelLower.contains('gnv')) {
      return 7;
    }
    return 1; // Default: Gasolina
  }

  @override
  Future<List<MarcaModel>> getMarcasByTipo(TipoVeiculo tipo) async {
    try {
      final tipoVeiculoCodigo = _getTipoVeiculoCodigo(tipo);

      AppLogger.d(
        'Buscando marcas para tipo $tipo (código: $tipoVeiculoCodigo)',
      );

      // Buscar marcas com estatísticas
      final response = await client.rpc(
        'get_marcas_com_estatisticas',
        params: {'p_tipo_veiculo': tipoVeiculoCodigo},
      );

      AppLogger.i(
        'Resposta recebida: ${response.length} marcas',
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
      AppLogger.e('Erro ao buscar marcas', e);
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
      AppLogger.d(
        'Buscando modelos para marca $marcaId (tipo: $tipo${ano != null ? ', ano: $ano' : ''})',
      );

      if (ano != null) {
        // Buscar apenas modelos disponíveis no ano especificado
        final tipoVeiculoCodigo = _getTipoVeiculoCodigo(tipo);

        final response = await client
            .from('modelos_anos')
            .select('''
              modelos!inner(
                codigo,
                nome,
                codigo_marca,
                tipo_veiculo
              ),
              anos_combustivel!inner(
                ano
              )
            ''')
            .eq('modelos.codigo_marca', marcaId.toString())
            .eq('modelos.tipo_veiculo', tipoVeiculoCodigo)
            .eq('anos_combustivel.ano', ano);

        AppLogger.i(
          'Resposta recebida com ${response.length} registros',
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

        AppLogger.i(
          '${modelos.length} modelos únicos encontrados',
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

      AppLogger.i(
        'Resposta recebida: ${response.length} modelos',
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
      AppLogger.e('Erro ao buscar modelos', e);
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
      final tipoVeiculoCodigo = _getTipoVeiculoCodigo(tipo);

      // Primeiro, buscar os códigos dos modelos da marca e tipo específicos
      final modelosResponse = await client
          .from('modelos')
          .select('codigo')
          .eq('codigo_marca', marcaId.toString())
          .eq('tipo_veiculo', tipoVeiculoCodigo);

      if (modelosResponse.isEmpty) {
        return [];
      }

      // Extrair lista de códigos de modelos
      final codigosModelos =
          modelosResponse.map((m) => m['codigo'].toString()).toList();

      // Buscar anos/combustíveis apenas desses modelos específicos
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
          .inFilter('codigo_modelo', codigosModelos)
          .order('anos_combustivel(ano)', ascending: false);

      // Remover duplicatas usando Set (por ano único)
      final anosUnicos = <String, AnoCombustivelModel>{};

      for (var json in response) {
        final anoCombustivel = json['anos_combustivel'];
        final ano = anoCombustivel['ano'] as String;

        // Usar ano como chave para manter apenas um registro por ano
        if (!anosUnicos.containsKey(ano)) {
          anosUnicos[ano] = AnoCombustivelModel.fromJson({
            'ano': ano,
            'combustivel': anoCombustivel['combustivel'],
            'codigo_fipe': anoCombustivel['codigo'],
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

      AppLogger.d(
        'Buscando valor FIPE - Marca: $marcaId, Modelo: $modeloId, Ano: $ano, Combustível: $combustivel (código: $codigoCombustivel), Tipo: $tipo',
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
        AppLogger.w(
          'Nenhum valor encontrado, pode ser necessário consultar API externa',
        );
        throw ServerException('Valor FIPE não encontrado para este veículo');
      }

      AppLogger.i(
        'Valor FIPE encontrado: ${response['valor']}',
      );
      return ValorFipeModel.fromJson(response);
    } catch (e) {
      AppLogger.e('Erro ao buscar valor FIPE', e);
      throw ServerException('Erro ao buscar valor FIPE: ${e.toString()}');
    }
  }

  @override
  Future<String> getUltimoMesReferencia() async {
    try {
      AppLogger.d('Buscando último mês de referência disponível');

      // Busca o último registro da tabela valores_fipe para obter o mes_referencia mais atual
      final response = await client
          .from('valores_fipe')
          .select('mes_referencia')
          .order('mes_referencia', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        throw ServerException(
          'Nenhum mês de referência encontrado no servidor',
        );
      }

      final mesRef = response['mes_referencia'] as String;
      AppLogger.i('Último mês de referência: $mesRef');

      return mesRef;
    } catch (e) {
      AppLogger.e('Erro ao buscar último mês de referência', e);
      throw ServerException(
        'Erro ao buscar mês de referência: ${e.toString()}',
      );
    }
  }
}
