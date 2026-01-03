import 'package:fipe/features/consulta_fipe/data/models/modelo_model.dart';
import 'package:fipe/features/consulta_fipe/domain/entities/modelo_entity.dart';

/// Fixtures de teste para Modelo
class ModeloFixture {
  /// JSON de modelo
  static Map<String, dynamic> get modeloJson => {
        'id': 100,
        'marca_id': 1,
        'nome': 'PALIO 1.0',
        'tipo': 'carro',
      };

  /// JSON de modelo 2
  static Map<String, dynamic> get modelo2Json => {
        'id': 101,
        'marca_id': 1,
        'nome': 'UNO 1.0',
        'tipo': 'carro',
      };

  /// JSON de modelo de moto
  static Map<String, dynamic> get modeloMotoJson => {
        'id': 200,
        'marca_id': 10,
        'nome': 'CG 160 FAN',
        'tipo': 'moto',
      };

  /// Lista de JSONs de modelos
  static List<Map<String, dynamic>> get modelosListJson => [
        modeloJson,
        modelo2Json,
        {
          'id': 102,
          'marca_id': 1,
          'nome': 'STRADA 1.4',
          'tipo': 'carro',
        },
      ];

  /// Model de modelo
  static const ModeloModel modeloModel = ModeloModel(
    id: 100,
    marcaId: 1,
    nome: 'PALIO 1.0',
    tipo: 'carro',
  );

  /// Model de modelo 2
  static const ModeloModel modelo2Model = ModeloModel(
    id: 101,
    marcaId: 1,
    nome: 'UNO 1.0',
    tipo: 'carro',
  );

  /// Entity de modelo
  static const ModeloEntity modeloEntity = ModeloEntity(
    id: 100,
    marcaId: 1,
    nome: 'PALIO 1.0',
    tipo: 'carro',
  );

  /// Entity de modelo 2
  static const ModeloEntity modelo2Entity = ModeloEntity(
    id: 101,
    marcaId: 1,
    nome: 'UNO 1.0',
    tipo: 'carro',
  );

  /// Lista de models
  static const List<ModeloModel> modelosModelList = [
    ModeloModel(
      id: 100,
      marcaId: 1,
      nome: 'PALIO 1.0',
      tipo: 'carro',
    ),
    ModeloModel(
      id: 101,
      marcaId: 1,
      nome: 'UNO 1.0',
      tipo: 'carro',
    ),
    ModeloModel(
      id: 102,
      marcaId: 1,
      nome: 'STRADA 1.4',
      tipo: 'carro',
    ),
  ];

  /// Lista de entities
  static const List<ModeloEntity> modelosEntityList = [
    ModeloEntity(
      id: 100,
      marcaId: 1,
      nome: 'PALIO 1.0',
      tipo: 'carro',
    ),
    ModeloEntity(
      id: 101,
      marcaId: 1,
      nome: 'UNO 1.0',
      tipo: 'carro',
    ),
    ModeloEntity(
      id: 102,
      marcaId: 1,
      nome: 'STRADA 1.4',
      tipo: 'carro',
    ),
  ];
}
