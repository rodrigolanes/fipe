import 'package:fipe/features/consulta_fipe/data/models/marca_model.dart';
import 'package:fipe/features/consulta_fipe/domain/entities/marca_entity.dart';

/// Fixtures de teste para Marca
class MarcaFixture {
  /// JSON de marca simples (sem estatísticas)
  static Map<String, dynamic> get marcaJson => {
        'id': 1,
        'nome': 'FIAT',
        'tipo': 'carro',
      };

  /// JSON de marca com estatísticas completas
  static Map<String, dynamic> get marcaComEstatisticasJson => {
        'id': 1,
        'nome': 'FIAT',
        'tipo': 'carro',
        'total_modelos': 150,
        'primeiro_ano': 1990,
        'ultimo_ano': 2026,
      };

  /// JSON de marca de moto
  static Map<String, dynamic> get marcaMotoJson => {
        'id': 10,
        'nome': 'HONDA',
        'tipo': 'moto',
        'total_modelos': 80,
        'primeiro_ano': 1985,
        'ultimo_ano': 2026,
      };

  /// JSON de marca de caminhão
  static Map<String, dynamic> get marcaCaminhaoJson => {
        'id': 100,
        'nome': 'VOLKSWAGEN',
        'tipo': 'caminhao',
        'total_modelos': 50,
        'primeiro_ano': 1980,
        'ultimo_ano': 2026,
      };

  /// Lista de JSONs de marcas
  static List<Map<String, dynamic>> get marcasListJson => [
        marcaJson,
        {
          'id': 2,
          'nome': 'VOLKSWAGEN',
          'tipo': 'carro',
          'total_modelos': 120,
          'primeiro_ano': 1988,
          'ultimo_ano': 2026,
        },
        {
          'id': 3,
          'nome': 'CHEVROLET',
          'tipo': 'carro',
          'total_modelos': 100,
          'primeiro_ano': 1992,
          'ultimo_ano': 2026,
        },
      ];

  /// Model de marca simples
  static const MarcaModel marcaModel = MarcaModel(
    id: 1,
    nome: 'FIAT',
    tipo: 'carro',
  );

  /// Model de marca com estatísticas
  static const MarcaModel marcaComEstatisticasModel = MarcaModel(
    id: 1,
    nome: 'FIAT',
    tipo: 'carro',
    totalModelos: 150,
    primeiroAno: 1990,
    ultimoAno: 2026,
  );

  /// Entity de marca simples
  static const MarcaEntity marcaEntity = MarcaEntity(
    id: 1,
    nome: 'FIAT',
    tipo: 'carro',
  );

  /// Entity de marca com estatísticas
  static const MarcaEntity marcaComEstatisticasEntity = MarcaEntity(
    id: 1,
    nome: 'FIAT',
    tipo: 'carro',
    totalModelos: 150,
    primeiroAno: 1990,
    ultimoAno: 2026,
  );

  /// Lista de models
  static const List<MarcaModel> marcasModelList = [
    MarcaModel(
      id: 1,
      nome: 'FIAT',
      tipo: 'carro',
      totalModelos: 150,
      primeiroAno: 1990,
      ultimoAno: 2026,
    ),
    MarcaModel(
      id: 2,
      nome: 'VOLKSWAGEN',
      tipo: 'carro',
      totalModelos: 120,
      primeiroAno: 1988,
      ultimoAno: 2026,
    ),
    MarcaModel(
      id: 3,
      nome: 'CHEVROLET',
      tipo: 'carro',
      totalModelos: 100,
      primeiroAno: 1992,
      ultimoAno: 2026,
    ),
  ];

  /// Lista de entities
  static const List<MarcaEntity> marcasEntityList = [
    MarcaEntity(
      id: 1,
      nome: 'FIAT',
      tipo: 'carro',
      totalModelos: 150,
      primeiroAno: 1990,
      ultimoAno: 2026,
    ),
    MarcaEntity(
      id: 2,
      nome: 'VOLKSWAGEN',
      tipo: 'carro',
      totalModelos: 120,
      primeiroAno: 1988,
      ultimoAno: 2026,
    ),
    MarcaEntity(
      id: 3,
      nome: 'CHEVROLET',
      tipo: 'carro',
      totalModelos: 100,
      primeiroAno: 1992,
      ultimoAno: 2026,
    ),
  ];
}
