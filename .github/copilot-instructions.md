# Diretrizes de Desenvolvimento - FIPE App

## � Idioma

**IMPORTANTE**: Todas as conversas, explicações, comentários e documentação devem ser em **Português Brasileiro (pt-BR)**.

- ✅ Respostas em português brasileiro
- ✅ Comentários de código em português
- ✅ Mensagens de commit em português
- ✅ Documentação em português

---

## �🎯 Visão Geral

Este documento define as diretrizes e boas práticas para o desenvolvimento da aplicação FIPE. Todos os desenvolvedores e o GitHub Copilot devem seguir estas orientações.

---

## 📐 Arquitetura

### Clean Architecture

O projeto segue os princípios da Clean Architecture com três camadas principais:

#### 1. **Domain Layer (Camada de Domínio)**

- **Responsabilidade**: Lógica de negócio pura
- **Localização**: `lib/features/[feature]/domain/`
- **Componentes**:
  - **Entities**: Classes de domínio sem dependências externas
  - **Repositories**: Interfaces (contratos) abstratas
  - **UseCases**: Lógica de negócio específica (Single Responsibility)

**Regras**:

- ✅ Zero dependências de frameworks externos
- ✅ Entities devem estender `Equatable` para comparação
- ✅ UseCases devem ter um único método `call()`
- ✅ Repositories são apenas interfaces (abstracts)

**Exemplo de Entity**:

```dart
import 'package:equatable/equatable.dart';

class MarcaEntity extends Equatable {
  final int id;
  final String nome;
  final String tipo;

  const MarcaEntity({
    required this.id,
    required this.nome,
    required this.tipo,
  });

  @override
  List<Object?> get props => [id, nome, tipo];
}
```

**Exemplo de UseCase**:

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetMarcasPorTipoUseCase implements UseCase<List<MarcaEntity>, TipoVeiculo> {
  final FipeRepository repository;

  GetMarcasPorTipoUseCase(this.repository);

  @override
  Future<Either<Failure, List<MarcaEntity>>> call(TipoVeiculo tipo) async {
    return await repository.getMarcasPorTipo(tipo);
  }
}
```

---

#### 2. **Data Layer (Camada de Dados)**

- **Responsabilidade**: Implementação de acesso a dados
- **Localização**: `lib/features/[feature]/data/`
- **Componentes**:
  - **Models**: Extensões de Entities com `fromJson()` e `toJson()`
  - **DataSources**: Interfaces para APIs e banco local
  - **Repositories**: Implementação dos contratos do Domain

**Regras**:

- ✅ Models estendem Entities
- ✅ Implementar `fromJson()` e `toJson()` em todos os models
- ✅ DataSources sempre com interface e implementação separadas
- ✅ Repositories convertem Models em Entities
- ✅ Tratamento de exceções nos DataSources

**⚠️ IMPORTANTE - Fluxo de Dados Supabase:**

- ❌ **NUNCA enviar dados para o Supabase** - Este é um projeto **somente leitura**
- ✅ **Apenas operações GET/SELECT** são permitidas no Supabase
- ✅ **Supabase é a fonte da verdade** - dados remotos sempre sobrescrevem dados locais
- ✅ **Cache local (Hive) é apenas para performance** - não persiste alterações
- ✅ **Sincronização unidirecional**: Supabase → Cache Local (nunca o contrário)
- ❌ Não implementar métodos de `insert`, `update` ou `delete` nos DataSources
- ❌ Não criar funcionalidades que tentem enviar dados ao servidor

**Estratégia de Cache:**

```dart
// ✅ CORRETO: Busca remota sobrescreve cache
1. Tenta buscar do cache local (se válido)
2. Se cache expirado/inválido, busca do Supabase
3. Dados do Supabase SEMPRE sobrescrevem o cache local
4. Cache é apenas para melhorar UX (modo offline parcial)
```

**Exemplo de Model**:

```dart
class MarcaModel extends MarcaEntity {
  const MarcaModel({
    required super.id,
    required super.nome,
    required super.tipo,
  });

  factory MarcaModel.fromJson(Map<String, dynamic> json) {
    return MarcaModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
    };
  }
}
```

**Exemplo de Repository Implementation**:

```dart
class FipeRepositoryImpl implements FipeRepository {
  final SupabaseDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  FipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MarcaEntity>>> getMarcasPorTipo(TipoVeiculo tipo) async {
    try {
      final marcas = await remoteDataSource.getMarcasByTipo(tipo);
      return Right(marcas);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
```

---

#### 3. **Presentation Layer (Camada de Apresentação)**

- **Responsabilidade**: UI e gerenciamento de estado
- **Localização**: `lib/features/[feature]/presentation/`
- **Componentes**:
  - **BLoC/Cubit**: Gerenciamento de estado
  - **Pages**: Telas completas
  - **Widgets**: Componentes reutilizáveis

**Regras**:

- ✅ Usar `flutter_bloc` para gerenciamento de estado
- ✅ BLoCs/Cubits devem ser injetados via GetIt
- ✅ Widgets devem ser stateless quando possível
- ✅ Separar lógica de apresentação da UI

**Exemplo de BLoC**:

```dart
class MarcaBloc extends Bloc<MarcaEvent, MarcaState> {
  final GetMarcasPorTipoUseCase getMarcasPorTipo;

  MarcaBloc({required this.getMarcasPorTipo}) : super(MarcaInitial()) {
    on<GetMarcasEvent>(_onGetMarcas);
  }

  Future<void> _onGetMarcas(
    GetMarcasEvent event,
    Emitter<MarcaState> emit,
  ) async {
    emit(MarcaLoading());

    final result = await getMarcasPorTipo(event.tipo);

    result.fold(
      (failure) => emit(MarcaError(message: _mapFailureToMessage(failure))),
      (marcas) => emit(MarcaLoaded(marcas: marcas)),
    );
  }
}
```

---

## 🏛️ Princípios SOLID

### 1. **Single Responsibility Principle (SRP)**

- Cada classe deve ter apenas uma razão para mudar
- UseCases devem ter apenas um método `call()`
- Widgets complexos devem ser quebrados em componentes menores

**❌ Errado**:

```dart
class VeiculoService {
  Future<List<Marca>> getMarcas() {}
  Future<List<Modelo>> getModelos() {}
  Future<void> saveFavorite() {}
  Future<void> shareVeiculo() {}
}
```

**✅ Correto**:

```dart
class GetMarcasUseCase { /* ... */ }
class GetModelosUseCase { /* ... */ }
class SaveFavoriteUseCase { /* ... */ }
class ShareVeiculoUseCase { /* ... */ }
```

---

### 2. **Open/Closed Principle (OCP)**

- Classes devem ser abertas para extensão, fechadas para modificação
- Usar abstrações e interfaces

**✅ Exemplo**:

```dart
abstract class DataSource {
  Future<List<MarcaModel>> getMarcas();
}

class SupabaseDataSourceImpl implements DataSource { /* ... */ }
class MockDataSourceImpl implements DataSource { /* ... */ }
```

---

### 3. **Liskov Substitution Principle (LSP)**

- Subtipos devem ser substituíveis por seus tipos base
- Models devem poder ser usados onde Entities são esperadas

---

### 4. **Interface Segregation Principle (ISP)**

- Não force classes a implementar interfaces que não usam
- Divida interfaces grandes em menores e específicas

**❌ Errado**:

```dart
abstract class FipeRepository {
  Future<List<Marca>> getMarcas();
  Future<List<Modelo>> getModelos();
  Future<void> saveFavorite();
  Future<void> shareVeiculo();
}
```

**✅ Correto**:

```dart
abstract class FipeRepository {
  Future<List<Marca>> getMarcas();
  Future<List<Modelo>> getModelos();
}

abstract class FavoriteRepository {
  Future<void> saveFavorite();
  Future<void> deleteFavorite();
}
```

---

### 5. **Dependency Inversion Principle (DIP)**

- Dependa de abstrações, não de implementações concretas
- Use injeção de dependências (GetIt)

**✅ Exemplo**:

```dart
// Depende de abstração
class MarcaBloc {
  final FipeRepository repository; // Interface, não implementação
  MarcaBloc({required this.repository});
}

// Configuração no injection_container.dart
sl.registerLazySingleton<FipeRepository>(
  () => FipeRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ),
);
```

---

## 🔧 Injeção de Dependências

### GetIt Configuration

**Arquivo**: `lib/injection_container.dart`

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // ✅ BLoCs - Factory (nova instância a cada chamada)
  sl.registerFactory(
    () => MarcaBloc(getMarcasPorTipo: sl()),
  );

  // ✅ UseCases - Lazy Singleton
  sl.registerLazySingleton(() => GetMarcasPorTipoUseCase(sl()));

  // ✅ Repositories - Lazy Singleton
  sl.registerLazySingleton<FipeRepository>(
    () => FipeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ✅ DataSources - Lazy Singleton
  sl.registerLazySingleton<SupabaseDataSource>(
    () => SupabaseDataSourceImpl(client: sl()),
  );

  // ✅ External - Singleton
  final supabase = await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  sl.registerSingleton<SupabaseClient>(supabase.client);
}
```

---

## 🎨 Padrões de Código

### Nomenclatura

- **Classes**: PascalCase (`MarcaEntity`, `GetMarcasUseCase`)
- **Arquivos**: snake_case (`marca_entity.dart`, `get_marcas_usecase.dart`)
- **Variáveis**: camelCase (`marcaEntity`, `isLoading`)
- **Constantes**: lowerCamelCase (`appTitle`, `defaultTimeout`)

### Estrutura de Arquivos

```
lib/features/consulta_fipe/
├── data/
│   ├── datasources/
│   │   ├── supabase_data_source.dart
│   │   └── local_data_source.dart
│   ├── models/
│   │   ├── marca_model.dart
│   │   └── modelo_model.dart
│   └── repositories/
│       └── fipe_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── marca_entity.dart
│   │   └── modelo_entity.dart
│   ├── repositories/
│   │   └── fipe_repository.dart
│   └── usecases/
│       ├── get_marcas_por_tipo_usecase.dart
│       └── get_modelos_por_marca_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── marca_bloc.dart
    │   ├── marca_event.dart
    │   └── marca_state.dart
    ├── pages/
    │   ├── marca_list_page.dart
    │   └── modelo_list_page.dart
    └── widgets/
        ├── marca_item_widget.dart
        └── loading_widget.dart
```

---

## 🧪 Testes

### ✅ Status Atual: 234 Testes Implementados

O projeto possui cobertura completa de testes em todas as camadas da Clean Architecture:

**📊 Breakdown por Camada:**
- **Domain Layer**: 65 testes (UseCases + Entities)
- **Data Layer**: 55 testes (Models + Repository)
- **Presentation Layer**: 85 testes (BLoCs + Widgets + Pages)
- **Core Layer**: 29 testes (Utils + Services + Theme)

**Total: 234 testes passando! ✅**

### Cobertura Mínima: 80%

#### Estrutura de Testes

```
test/
├── core/
│   ├── theme/
│   │   └── theme_manager_test.dart (10 testes)
│   └── utils/
│       ├── mes_referencia_formatter_test.dart (21 testes)
│       └── share_service_test.dart (4 testes)
├── features/
│   └── consulta_fipe/
│       ├── data/
│       │   ├── models/
│       │   │   ├── ano_combustivel_model_test.dart (9 testes)
│       │   │   ├── marca_model_test.dart (9 testes)
│       │   │   ├── modelo_model_test.dart (10 testes)
│       │   │   └── valor_fipe_model_test.dart (10 testes)
│       │   └── repositories/
│       │       └── consulta_fipe_repository_test.dart (17 testes)
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── ano_combustivel_entity_test.dart (9 testes)
│       │   │   ├── marca_entity_test.dart (6 testes)
│       │   │   ├── modelo_entity_test.dart (7 testes)
│       │   │   └── valor_fipe_entity_test.dart (8 testes)
│       │   └── usecases/
│       │       ├── get_anos_combustiveis_por_modelo_usecase_test.dart (7 testes)
│       │       ├── get_anos_por_marca_usecase_test.dart (6 testes)
│       │       ├── get_marcas_por_tipo_usecase_test.dart (7 testes)
│       │       ├── get_modelos_por_marca_usecase_test.dart (8 testes)
│       │       └── get_valor_fipe_usecase_test.dart (7 testes)
│       └── presentation/
│           ├── bloc/
│           │   ├── ano_combustivel_bloc_test.dart (11 testes)
│           │   ├── marca_bloc_test.dart (8 testes)
│           │   ├── modelo_bloc_test.dart (11 testes)
│           │   └── valor_fipe_bloc_test.dart (11 testes)
│           ├── pages/
│           │   ├── ano_combustivel_page_test.dart (1 teste)
│           │   ├── home_page_test.dart (9 testes)
│           │   ├── marca_list_page_test.dart (3 testes)
│           │   ├── modelo_list_page_test.dart (1 teste)
│           │   └── valor_detalhes_page_test.dart (1 teste)
│           └── widgets/
│               ├── error_widget_test.dart (3 testes)
│               ├── loading_widget_test.dart (3 testes)
│               ├── marca_item_widget_test.dart (7 testes)
│               ├── modelo_item_widget_test.dart (6 testes)
│               ├── search_bar_widget_test.dart (5 testes)
│               └── valor_card_widget_test.dart (9 testes)
├── fixtures/
│   ├── ano_combustivel_fixture.dart
│   ├── marca_fixture.dart
│   ├── modelo_fixture.dart
│   └── valor_fipe_fixture.dart
└── helpers/
    └── test_helper.dart (mocks gerados com Mockito)
```

### Padrões de Teste Implementados

#### 1. **Testes de Domain (UseCases e Entities)**

**UseCases:**
```dart
void main() {
  late GetMarcasPorTipoUseCase usecase;
  late MockFipeRepository mockRepository;

  setUp(() {
    mockRepository = MockFipeRepository();
    usecase = GetMarcasPorTipoUseCase(mockRepository);
  });

  test('deve retornar lista de marcas quando repository retornar sucesso', () async {
    // Arrange
    when(mockRepository.getMarcasPorTipo(any))
        .thenAnswer((_) async => Right(tMarcaList));

    // Act
    final result = await usecase(TipoVeiculo.carro);

    // Assert
    expect(result, Right(tMarcaList));
    verify(mockRepository.getMarcasPorTipo(TipoVeiculo.carro));
    verifyNoMoreInteractions(mockRepository);
  });

  test('deve retornar ServerFailure quando repository falhar', () async {
    // Arrange
    when(mockRepository.getMarcasPorTipo(any))
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(TipoVeiculo.carro);

    // Assert
    expect(result, Left(ServerFailure()));
    verify(mockRepository.getMarcasPorTipo(TipoVeiculo.carro));
  });
}
```

**Entities:**
```dart
void main() {
  const tMarca1 = MarcaEntity(id: 1, nome: 'Fiat', tipo: 'carros');
  const tMarca2 = MarcaEntity(id: 1, nome: 'Fiat', tipo: 'carros');
  const tMarca3 = MarcaEntity(id: 2, nome: 'Ford', tipo: 'carros');

  group('MarcaEntity', () {
    test('deve ter os atributos corretos', () {
      expect(tMarca1.id, 1);
      expect(tMarca1.nome, 'Fiat');
      expect(tMarca1.tipo, 'carros');
    });

    test('deve ser igual quando tiver os mesmos valores (Equatable)', () {
      expect(tMarca1, equals(tMarca2));
    });

    test('deve ser diferente quando tiver valores diferentes', () {
      expect(tMarca1, isNot(equals(tMarca3)));
    });
  });
}
```

#### 2. **Testes de Data (Models e Repository)**

**Models:**
```dart
void main() {
  const tMarcaModel = MarcaModel(id: 1, nome: 'FIAT', tipo: 'carros');

  group('MarcaModel', () {
    test('deve ser uma subclasse de MarcaEntity', () {
      expect(tMarcaModel, isA<MarcaEntity>());
    });

    test('deve retornar um Model válido a partir de JSON', () {
      final json = {'id': 1, 'nome': 'FIAT', 'tipo': 'carros'};
      final result = MarcaModel.fromJson(json);
      expect(result, equals(tMarcaModel));
    });

    test('deve retornar um JSON válido a partir do Model', () {
      final result = tMarcaModel.toJson();
      expect(result, {
        'id': 1,
        'nome': 'FIAT',
        'tipo': 'carros',
      });
    });
  });
}
```

**Repository:**
```dart
void main() {
  late ConsultaFipeRepositoryImpl repository;
  late MockConsultaFipeRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockConsultaFipeRemoteDataSource();
    repository = ConsultaFipeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('getMarcasPorTipo', () {
    test('deve retornar lista de marcas quando chamada for bem-sucedida', () async {
      // Arrange
      when(mockRemoteDataSource.getMarcasPorTipo(any))
          .thenAnswer((_) async => tMarcaModelList);

      // Act
      final result = await repository.getMarcasPorTipo(TipoVeiculo.carro);

      // Assert
      verify(mockRemoteDataSource.getMarcasPorTipo(TipoVeiculo.carro));
      expect(result, equals(Right(tMarcaModelList)));
    });

    test('deve retornar ServerFailure quando chamada falhar', () async {
      // Arrange
      when(mockRemoteDataSource.getMarcasPorTipo(any))
          .thenThrow(ServerException());

      // Act
      final result = await repository.getMarcasPorTipo(TipoVeiculo.carro);

      // Assert
      expect(result, equals(Left(ServerFailure())));
    });
  });
}
```

#### 3. **Testes de Presentation (BLoCs e Widgets)**

**BLoCs:**
```dart
void main() {
  late MarcaBloc bloc;
  late MockGetMarcasPorTipoUseCase mockGetMarcasPorTipo;

  setUp(() {
    mockGetMarcasPorTipo = MockGetMarcasPorTipoUseCase();
    bloc = MarcaBloc(getMarcasPorTipo: mockGetMarcasPorTipo);
  });

  test('estado inicial deve ser MarcaInitial', () {
    expect(bloc.state, equals(MarcaInitial()));
  });

  blocTest<MarcaBloc, MarcaState>(
    'deve emitir [Loading, Loaded] quando dados forem obtidos com sucesso',
    build: () {
      when(mockGetMarcasPorTipo(any))
          .thenAnswer((_) async => Right(tMarcaList));
      return bloc;
    },
    act: (bloc) => bloc.add(GetMarcasEvent(TipoVeiculo.carro)),
    expect: () => [
      MarcaLoading(),
      MarcaLoaded(marcas: tMarcaList),
    ],
    verify: (_) {
      verify(mockGetMarcasPorTipo(TipoVeiculo.carro));
    },
  );
}
```

**Widgets:**
```dart
void main() {
  testWidgets('LoadingWidget deve exibir shimmer effect', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoadingWidget())),
    );

    expect(find.byType(Shimmer), findsWidgets);
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('MarcaItemWidget deve exibir nome da marca', (tester) async {
    const marca = MarcaEntity(id: 1, nome: 'FIAT', tipo: 'carros');
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MarcaItemWidget(marca: marca, onTap: () {}),
        ),
      ),
    );

    expect(find.text('FIAT'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });
}
```

**Pages (testes estruturais):**
```dart
void main() {
  testWidgets('HomePage deve renderizar estrutura básica', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage()),
    );

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });
}
```

#### 4. **Testes de Core (Utils e Services)**

**Formatters:**
```dart
void main() {
  group('MesReferenciaFormatter', () {
    test('deve formatar "janeiro de 2023" corretamente', () {
      expect(
        MesReferenciaFormatter.format('janeiro de 2023'),
        equals('Janeiro de 2023'),
      );
    });

    test('deve retornar string original se formato for inválido', () {
      expect(
        MesReferenciaFormatter.format('formato invalido'),
        equals('formato invalido'),
      );
    });

    test('extension deve formatar corretamente', () {
      expect(
        'janeiro de 2023'.formatMesReferencia(),
        equals('Janeiro de 2023'),
      );
    });
  });
}
```

**Services:**
```dart
void main() {
  late ShareService shareService;

  setUp(() {
    shareService = ShareService();
  });

  test('deve formatar mensagem de compartilhamento corretamente', () {
    const valor = ValorFipeEntity(
      marca: 'FIAT',
      modelo: 'UNO',
      anoModelo: 2020,
      valor: 'R\$ 50.000,00',
      combustivel: 'Gasolina',
      codigoFipe: '001004-1',
      mesReferencia: 'janeiro de 2023',
      tipoVeiculo: 1,
      siglaCombustivel: 'G',
    );

    final message = shareService.formatShareMessage(valor);

    expect(message, contains('FIAT UNO'));
    expect(message, contains('2020'));
    expect(message, contains('R\$ 50.000,00'));
  });
}
```

**Theme Manager:**
```dart
void main() {
  late ThemeManager themeManager;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    themeManager = ThemeManager();
    await themeManager.init();
  });

  test('deve alternar entre temas', () {
    expect(themeManager.isDarkMode, false);
    
    themeManager.toggleTheme();
    expect(themeManager.isDarkMode, true);
    
    themeManager.toggleTheme();
    expect(themeManager.isDarkMode, false);
  });

  test('deve notificar listeners quando tema mudar', () {
    var notified = false;
    themeManager.addListener(() => notified = true);
    
    themeManager.toggleTheme();
    expect(notified, true);
  });
}
```

### Comandos de Teste

```bash
# Executar todos os testes
flutter test

# Executar com verbosidade
flutter test --verbose

# Executar sem atualizar dependências
flutter test --no-pub

# Executar testes de uma pasta específica
flutter test test/features/consulta_fipe/domain/

# Executar um arquivo específico
flutter test test/features/consulta_fipe/domain/entities/marca_entity_test.dart

# Gerar relatório de cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Fixtures e Helpers

**Fixtures** (`test/fixtures/`):
- Dados de teste reutilizáveis
- Mantém consistência entre testes
- Facilita manutenção

**Helpers** (`test/helpers/`):
- `test_helper.dart`: Configuração do Mockito
- Gera mocks com `@GenerateMocks`
- Build runner: `flutter pub run build_runner build`

### Boas Práticas de Teste

✅ **SEMPRE:**
- Usar `setUp()` para inicialização
- Nomear testes descritivamente em português
- Seguir padrão AAA (Arrange, Act, Assert)
- Mockar dependências externas
- Usar fixtures para dados de teste
- Verificar interações com `verify()`
- Limpar com `verifyNoMoreInteractions()`
- Testar casos de sucesso E falha
- Executar `flutter test` antes de commit

❌ **NUNCA:**
- Fazer requisições reais em testes unitários
- Depender de ordem de execução
- Compartilhar estado entre testes
- Ignorar testes que falham
- Commitar sem executar testes

### Integração com CI/CD

Os testes são executados automaticamente no GitHub Actions:

```yaml
# .github/workflows/test.yml
- name: Run tests
  run: flutter test --coverage
  
- name: Check coverage
  run: |
    if [ $(lcov --summary coverage/lcov.info | grep 'lines' | grep -o '[0-9.]*%' | grep -o '[0-9.]*' | awk '{print ($1 < 80)}') -eq 1 ]; then
      echo "Code coverage is below 80%"
      exit 1
    fi
```

---

## 🚀 Boas Práticas

### 1. **Tratamento de Erros**

```dart
// lib/core/error/failures.dart
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}
class CacheFailure extends Failure {}
class NetworkFailure extends Failure {}

// lib/core/error/exceptions.dart
class ServerException implements Exception {}
class CacheException implements Exception {}
```

### 2. **Constants**

```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'FIPE Consulta';
  static const int cacheTimeout = 3600; // 1 hora
  static const int paginationLimit = 50;
}
```

### 3. **Extensions**

```dart
// lib/core/extensions/string_extensions.dart
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
```

### 4. **Widgets Reutilizáveis**

- Sempre extrair widgets complexos
- Usar `const` sempre que possível
- Criar widgets em `lib/core/widgets/` se usados em múltiplas features

---

## 📱 UI/UX Guidelines

### Material Design 3

- Usar componentes do Material 3
- Seguir paleta de cores definida em `app_theme.dart`
- Garantir contraste adequado (WCAG AA)

### Responsividade

- Testar em múltiplos tamanhos de tela
- Usar `MediaQuery` e `LayoutBuilder`
- Suportar orientação portrait e landscape

### Performance

- Lazy loading em listas longas
- Image caching com `cached_network_image`
- Debounce em campos de busca (300ms)
- Usar `const` construtores sempre que possível

---

## 🔒 Segurança

### Configurações Sensíveis

- **NUNCA** commitar credenciais no Git
- Usar arquivos `.gitignore` para `supabase_config.dart` e `admob_config.dart`
- Variáveis sensíveis em GitHub Secrets para CI/CD

### Row Level Security (RLS)

- Todas as tabelas do Supabase devem ter RLS habilitado
- Apenas leitura pública para dados FIPE

---

## 📊 CI/CD

### ⚠️ OBRIGATÓRIO: Antes de Cada Commit

**IMPORTANTE**: Sempre execute os seguintes comandos antes de commitar qualquer código:

```bash
# 1. Formatar código (OBRIGATÓRIO - corrige formatação automaticamente)
dart format .

# 2. Verificar formatação (OBRIGATÓRIO - CI/CD usa este comando)
dart format --output=none --set-exit-if-changed .

# 3. Analisar código (OBRIGATÓRIO - deve retornar 0 issues)
flutter analyze

# 4. Executar testes (OBRIGATÓRIO - todos devem passar)
flutter test

# 5. Verificar cobertura (opcional, mas recomendado)
flutter test --coverage
```

**❌ NÃO COMMITE SE:**

- `dart format --set-exit-if-changed` retornar exit code 1 (arquivos não formatados)
- `flutter analyze` retornar warnings ou erros
- `flutter test` tiver testes falhando
- Houver código não formatado

**✅ SÓ COMMITE QUANDO:**

- `dart format --set-exit-if-changed .` retornar exit code 0 (nenhum arquivo alterado)
- Todos os testes passarem
- `flutter analyze` não retornar issues
- Código estiver 100% formatado

**⚠️ ERRO COMUM NO CI/CD:**

Se o GitHub Actions falhar com erro "Changed X files", significa que você commitou código não formatado:

```
Changed lib/features/consulta_fipe/data/models/ano_combustivel_model.dart
Changed lib/features/consulta_fipe/data/models/modelo_model.dart
Formatted 112 files (3 changed) in 2.38 seconds.
Error: Process completed with exit code 1.
```

**Solução:**
1. Execute `dart format .` localmente
2. Commit as alterações formatadas
3. Push novamente

### 🤖 OBRIGATÓRIO: Validação pelo GitHub Copilot

**REGRA CRÍTICA**: O GitHub Copilot DEVE executar `flutter analyze` antes de concluir QUALQUER tarefa que envolva:
- Criação de novos arquivos Dart
- Modificação de código existente
- Refatoração de classes/widgets
- Adição de imports
- Qualquer alteração em arquivos `.dart`

**Fluxo Obrigatório do Copilot:**

1. ✅ Implementar a mudança solicitada
2. ✅ Executar `flutter analyze` via terminal
3. ✅ Se houver erros/warnings:
   - Corrigir TODOS os problemas
   - Re-executar `flutter analyze`
   - Repetir até 0 issues
4. ✅ Somente após 0 issues, informar que a tarefa está completa

**❌ NUNCA:**
- Dizer que está "pronto" sem executar `flutter analyze`
- Ignorar warnings/info do analyzer
- Deixar erros de importação não resolvidos
- Assumir que o código está correto sem validação

**✅ SEMPRE:**
- Executar `flutter analyze` após cada mudança
- Corrigir todos os problemas encontrados
- Validar que não há erros de compilação
- Verificar que todos os imports estão corretos

### GitHub Actions

- Build automatizado em cada push
- Testes obrigatórios antes de merge
- Deploy automatizado com tags `v*.*.*`

---

## 📝 Documentação

### Comentários de Código

- Usar `///` para documentação pública
- Explicar o "porquê", não o "o quê"
- Documentar parâmetros complexos

```dart
/// Busca marcas de veículos por tipo.
///
/// Retorna uma lista de [MarcaEntity] ou uma [Failure] em caso de erro.
/// O parâmetro [tipo] define se é carro, moto ou caminhão.
Future<Either<Failure, List<MarcaEntity>>> getMarcasPorTipo(TipoVeiculo tipo);
```

---

## ✅ Checklist de Code Review

- [ ] Segue Clean Architecture (Domain → Data → Presentation)
- [ ] Aplica princípios SOLID
- [ ] Usa injeção de dependências (GetIt)
- [ ] Tem testes unitários (cobertura > 80%)
- [ ] Sem dependências desnecessárias
- [ ] Código formatado (`flutter format`)
- [ ] Sem warnings no Analyzer
- [ ] Widgets são `const` quando possível
- [ ] Tratamento de erros implementado
- [ ] Documentação adequada

---

## 🎯 Objetivos de Qualidade

| Métrica              | Alvo   |
| -------------------- | ------ |
| Cobertura de Testes  | > 80%  |
| Warnings do Analyzer | 0      |
| Tempo de Build       | < 2min |
| Tamanho do APK       | < 20MB |
| Tempo de Startup     | < 3s   |

---

**Última atualização**: 2 de janeiro de 2026
