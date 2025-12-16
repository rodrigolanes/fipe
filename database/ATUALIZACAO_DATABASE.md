# Instruções de Atualização do Banco de Dados

## Novas Funcionalidades Implementadas

### 1. Estatísticas das Marcas

As marcas agora exibem informações adicionais:

- Quantidade total de modelos
- Primeiro ano disponível
- Último ano disponível
- Status (Ativa/Inativa)

### 2. Filtro de Ano na Lista de Modelos

O fluxo foi otimizado para melhorar a experiência do usuário:

- **Fluxo**: Tipo → Marca → Modelos (com filtro de ano opcional) → Ano/Combustível → Valor
- Na página de modelos, o usuário pode filtrar por ano para reduzir a lista
- O filtro é opcional - por padrão mostra todos os modelos

## Passos para Configuração

### 1. Executar Função SQL no Supabase

Acesse o [Supabase SQL Editor](https://supabase.com/dashboard/project/frnfahrjfmnggeaccyty/sql/new) e execute o seguinte SQL:

```sql
-- Função para buscar marcas com estatísticas
CREATE OR REPLACE FUNCTION get_marcas_com_estatisticas(p_tipo_veiculo INTEGER)
RETURNS TABLE (
  codigo INTEGER,
  nome VARCHAR,
  tipo_veiculo INTEGER,
  total_modelos BIGINT,
  primeiro_ano INTEGER,
  ultimo_ano INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.codigo,
    m.nome,
    m.tipo_veiculo,
    COUNT(DISTINCT mo.codigo) AS total_modelos,
    MIN(
      CASE
        WHEN ac.ano = '32000' THEN NULL
        ELSE CAST(ac.ano AS INTEGER)
      END
    ) AS primeiro_ano,
    MAX(
      CASE
        WHEN ac.ano = '32000' THEN NULL
        ELSE CAST(ac.ano AS INTEGER)
      END
    ) AS ultimo_ano
  FROM marcas m
  LEFT JOIN modelos mo ON m.codigo = mo.codigo_marca
  LEFT JOIN modelos_anos ma ON mo.codigo = ma.codigo_modelo AND mo.codigo_marca = ma.codigo_marca
  LEFT JOIN anos_combustivel ac ON ma.codigo_ano_combustivel = ac.codigo
  WHERE m.tipo_veiculo = p_tipo_veiculo
  GROUP BY m.codigo, m.nome, m.tipo_veiculo
  ORDER BY m.nome ASC;
END;
$$ LANGUAGE plpgsql;

-- Garantir permissões
GRANT EXECUTE ON FUNCTION get_marcas_com_estatisticas(INTEGER) TO authenticated, anon;
```

### 2. Testar a Aplicação

Após executar o SQL, você pode testar a aplicação:

```bash
flutter run -d edge
```

## Arquivos Modificados

### Domain Layer

- `marca_entity.dart` - Adicionados campos: `totalModelos`, `primeiroAno`, `ultimoAno`
- `fipe_repository.dart` - Adicionado método `getAnosPorMarca` e parâmetro `ano` opcional em `getModelosPorMarca`
- `get_anos_por_marca_usecase.dart` - Novo use case para buscar anos por marca
- `get_modelos_por_marca_usecase.dart` - Adicionado parâmetro `ano` opcional

### Data Layer

- `marca_model.dart` - Adicionados campos e atualizado HiveType
- `fipe_remote_data_source.dart` - Novos métodos: `getAnosPorMarca` e parâmetro `ano`
- `fipe_remote_data_source_impl.dart` - Implementação dos novos métodos
- `fipe_repository_impl.dart` - Implementação dos novos métodos

### Presentation Layer

- `marca_item_widget.dart` - Novo design com cards informativos
- `modelo_list_page.dart` - Filtro de ano opcional com FilterChips
- `ano_combustivel_event.dart` - Novo evento `LoadAnosPorMarcaEvent`
- `ano_combustivel_bloc.dart` - Handler para o novo evento
- `modelo_event.dart` - Adicionado campo `ano` ao `LoadModelosPorMarcaEvent`
- `modelo_bloc.dart` - Passa `ano` para o use case

### Core

- `app_routes.dart` - Removida rota intermediária `/anos-selecao`
- `injection_container.dart` - Registrado novo use case

### Database

- `database/functions/get_marcas_com_estatisticas.sql` - Função SQL para estatísticas

## Benefícios

1. **Melhor UX**: Usuário vê todos os modelos mas pode filtrar por ano se desejar
2. **Informação Rica**: Cards de marcas mostram histórico e status
3. **Performance**: Consultas filtradas retornam apenas dados relevantes quando filtro está ativo
4. **Visual Aprimorado**: Design mais informativo e profissional
5. **Flexibilidade**: Filtro opcional não força o usuário a escolher ano

## Próximos Passos

Após executar o SQL, todos os recursos estarão funcionais:

- ✅ Cards informativos de marcas
- ✅ Filtro de ano opcional na página de modelos
- ✅ FilterChips para seleção rápida de ano
- ✅ Modal com todos os anos disponíveis
- ✅ Indicador de marcas ativas/inativas
