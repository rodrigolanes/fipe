# Sistema de Logging

## Visão Geral

O projeto utiliza a biblioteca `logger` para gerenciar logs de forma estruturada e organizada, substituindo o uso de `print()` e `debugPrint()`.

## Configuração

O logger está configurado na classe `AppLogger` localizada em `lib/core/utils/app_logger.dart`.

### Características

- **Cores e emojis**: Facilita a visualização no console de desenvolvimento
- **Níveis de log**: Debug, Info, Warning, Error, Fatal
- **Stack trace**: Captura automática em erros
- **Timestamp**: Registra quando cada log foi gerado
- **Configuração para produção**: Logger otimizado sem cores e com menos verbosidade

## Como Usar

### Importar o Logger

```dart
import 'package:fipe/core/utils/app_logger.dart';
```

### Níveis de Log

#### 1. Debug (Verbose)
Usado para informações detalhadas durante o desenvolvimento:

```dart
AppLogger.d('Carregando modelos para marca $marcaId');
AppLogger.d('Parâmetros: $params');
```

#### 2. Info
Informações gerais sobre o fluxo da aplicação:

```dart
AppLogger.i('${modelos.length} modelos carregados com sucesso');
AppLogger.i('Usuário autenticado');
```

#### 3. Warning
Avisos sobre situações que merecem atenção, mas não são erros:

```dart
AppLogger.w('Nenhum valor encontrado no cache');
AppLogger.w('Banner ad failed to load', error);
```

#### 4. Error
Erros que precisam ser investigados:

```dart
AppLogger.e('Erro ao carregar marcas', error);
AppLogger.e('Falha na requisição', error, stackTrace);
```

#### 5. Fatal
Erros críticos que impedem o funcionamento da aplicação:

```dart
AppLogger.f('Falha crítica no banco de dados', error, stackTrace);
```

## Exemplos Práticos

### BLoC Events

```dart
Future<void> _onLoadMarcas(
  LoadMarcasEvent event,
  Emitter<MarcaState> emit,
) async {
  AppLogger.d('Carregando marcas para tipo: ${event.tipo}');
  
  final result = await getMarcas(event.tipo);
  
  result.fold(
    (failure) => AppLogger.e('Erro ao carregar marcas', failure),
    (marcas) => AppLogger.i('${marcas.length} marcas carregadas'),
  );
}
```

### Data Sources

```dart
Future<List<MarcaModel>> getMarcas() async {
  try {
    AppLogger.d('Iniciando requisição de marcas');
    
    final response = await client.get('/marcas');
    
    AppLogger.i('Resposta recebida: ${response.length} marcas');
    return response.map((e) => MarcaModel.fromJson(e)).toList();
  } catch (e, stackTrace) {
    AppLogger.e('Erro ao buscar marcas', e, stackTrace);
    throw ServerException('Falha na requisição');
  }
}
```

## Boas Práticas

### ✅ Faça

- Use `AppLogger.d()` para logs de desenvolvimento
- Use `AppLogger.i()` para marcos importantes no fluxo
- Use `AppLogger.w()` para situações anormais que não são erros
- Use `AppLogger.e()` para erros com contexto adequado
- Inclua informações relevantes no log
- Passe error e stackTrace quando disponíveis

### ❌ Não Faça

- Não use `print()` ou `debugPrint()`
- Não logue informações sensíveis (senhas, tokens, etc.)
- Não logue objetos muito grandes sem formatação
- Não use apenas texto genérico ("erro", "sucesso")

## Vantagens sobre print()

1. **Níveis de log**: Filtre por importância
2. **Formatação**: Saída colorida e estruturada
3. **Stack trace**: Rastreamento automático de erros
4. **Timestamp**: Saiba quando cada evento ocorreu
5. **Configurável**: Ajuste verbosidade por ambiente
6. **Profissional**: Padrão da indústria
