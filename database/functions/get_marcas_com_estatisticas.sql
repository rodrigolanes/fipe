-- Função para buscar marcas com estatísticas
-- Execute este SQL no Supabase SQL Editor

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

-- Garantir que a função pode ser executada por usuários autenticados e anônimos
GRANT EXECUTE ON FUNCTION get_marcas_com_estatisticas(INTEGER) TO authenticated, anon;
