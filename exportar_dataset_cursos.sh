#!/bin/bash

API_URL="http://localhost:1129/cursos"
CSV_OUT="dataset_analitico.csv"

echo "[FLUXO] Extraindo dados brutos da API..."
DADOS_JSON=$(curl -sf "$API_URL")

# [ERRO] Verificando se a API respondeu com conteúdo válido
if [ $? -ne 0 ] || [ -z "$DADOS_JSON" ]; then
  echo "[ERRO] Falha na extração: API offline ou erro HTTP."
  exit 1
fi

if ! echo "$DADOS_JSON" | jq -e 'length > 0' > /dev/null 2>&1; then
  echo "[ERRO] Resposta inválida ou sem registros. Retorno da API:"
  echo "$DADOS_JSON"
  exit 1
fi

# [TRANSF] Convertendo JSON para formato tabular CSV usando jq
echo "[TRANSF] Transformando JSON em CSV..."
echo "$DADOS_JSON" | jq -r '(["ID","NOME","CARGA_HORARIA","INSTRUTOR","STATUS"] | @csv), (.[] | [.id, .nome, .carga_horaria, .instrutor, .status] | @csv)' > "$CSV_OUT"

echo "[SUCESSO] Dataset gerado em $CSV_OUT:"
cat "$CSV_OUT"
