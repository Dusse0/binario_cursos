
#!/bin/bash

echo "===================================================="
echo " TESTES DE CRUD - BINARIO CURSOS"
echo "===================================================="

echo -e "\n[1] Cadastrando um curso..."
RESP=$(curl -s -X POST http://localhost:1129/cursos \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Curso de Teste",
    "descricao": "Teste da API",
    "cargaHoraria": 40,
    "categoria": "Tecnologia",
    "instrutor": "Instrutor Teste"
  }')
echo "$RESP" | jq .

CURSO_ID=$(echo "$RESP" | jq -r '._id')

echo -e "\n[2] Listando cursos..."
curl -s http://localhost:1129/cursos | jq .

echo -e "\n[3] Filtrando cursos por nome..."
curl -s "http://localhost:1129/cursos?nome=Curso%20de%20Teste" | jq .

echo -e "\n[4] Atualizando curso (ID: $CURSO_ID)..."
curl -s -X PATCH "http://localhost:1129/cursos/$CURSO_ID" \
  -H "Content-Type: application/json" \
  -d '{"status":"Inativo"}' | jq .

echo -e "\n[5] Cadastrando matrícula..."
RESP=$(curl -s -X POST http://localhost:1129/matriculas \
  -H "Content-Type: application/json" \
  -d "{
    \"nomeAluno\": \"Aluno Teste\",
    \"emailAluno\": \"aluno@gmail.com\",
    \"curso\": \"$CURSO_ID\"
  }")
echo "$RESP" | jq .

MATRICULA_ID=$(echo "$RESP" | jq -r '._id')

echo -e "\n[6] Listando matrículas..."
curl -s http://localhost:1129/matriculas | jq .

echo -e "\n[7] Atualizando matrícula (ID: $MATRICULA_ID)..."
curl -s -X PATCH "http://localhost:1129/matriculas/$MATRICULA_ID" \
  -H "Content-Type: application/json" \
  -d '{"status":"TRANCADA"}' | jq .

echo -e "\n[8] Excluindo matrícula..."
curl -s -X DELETE "http://localhost:1129/matriculas/$MATRICULA_ID" | jq .

echo -e "\n[9] Excluindo curso..."
curl -s -X DELETE "http://localhost:1129/cursos/$CURSO_ID" | jq .

echo -e "\n[10] Testando cadastro inválido de curso..."
curl -s -X POST http://localhost:1129/cursos \
  -H "Content-Type: application/json" \
  -d '{}' | jq .

echo -e "\n[11] Testando curso inexistente (404)..."
curl -s -X PATCH http://localhost:1129/cursos/000000000000000000000000 \
  -H "Content-Type: application/json" \
  -d '{"status":"Ativo"}' | jq .

echo "===================================================="
echo " TESTES FINALIZADOS"
echo "===================================================="


