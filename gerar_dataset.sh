
#!/bin/bash

API="http://localhost:1129"

# [FLUXO] Extrai os dados da API
cursos=$(curl -fsS "$API/cursos") || {
    echo "Erro ao buscar cursos."
    exit 1
}

matriculas=$(curl -fsS "$API/matriculas") || {
    echo "Erro ao buscar matriculas."
    exit 1
}

# [ERRO] Verifica se os dados recebidos sao arrays JSON
if ! echo "$cursos" | jq -e 'type == "array"' >/dev/null ||
   ! echo "$matriculas" | jq -e 'type == "array"' >/dev/null; then
    echo "Erro: resposta invalida da API."
    exit 1
fi

# [TRANSF] Transforma os cursos em CSV
echo "$cursos" | jq -r '
    (["ID","NOME","CATEGORIA","CARGA_HORARIA","INSTRUTOR","STATUS"] | @csv),
    (.[] | [
        ._id,
        .nome,
        .categoria,
        .cargaHoraria,
        .instrutor,
        .status
    ] | @csv)
' > dataset_cursos.csv

# [TRANSF] Transforma as matriculas em CSV
echo "$matriculas" | jq -r '
    (["ID","ALUNO","EMAIL","CURSO_ID","DATA_MATRICULA","STATUS"] | @csv),
    (.[] | [
        ._id,
        .nomeAluno,
        .emailAluno,
        .curso,
        .dataMatricula,
        .status
    ] | @csv)
' > dataset_matriculas.csv

# [FLUXO] Confirma a geracao dos arquivos
echo
echo "Datasets gerados com sucesso!"
echo "Arquivo: dataset_cursos.csv"
echo "Arquivo: dataset_matriculas.csv"

# [TRANSF] Calcula metricas dos cursos
echo
echo "===== ANALISE DOS CURSOS ====="

echo "$cursos" | jq '
    "Total de cursos: \(length)",
    "Cursos ativos: \([.[] | select(.status == "Ativo")] | length)",
    "Cursos inativos: \([.[] | select(.status == "Inativo")] | length)"
'

# [TRANSF] Calcula metricas das matriculas
echo
echo "===== ANALISE DAS MATRICULAS ====="

echo "$matriculas" | jq '
    "Total de matriculas: \(length)",
    "Ativas: \([.[] | select(.status == "ATIVA")] | length)",
    "Trancadas: \([.[] | select(.status == "TRANCADA")] | length)",
    "Canceladas: \([.[] | select(.status == "CANCELADA")] | length)",
    "Suspensas: \([.[] | select(.status == "SUSPENSA")] | length)",
    "Concluidas: \([.[] | select(.status == "CONCLUIDA")] | length)"
'

echo
echo "Pipeline finalizado."
