# BINÁRIO CURSOS

## 1. Apresentação

A **Binário Cursos** é uma API RESTful desenvolvida como projeto final da disciplina de Programação Back-End 1 (PBE1), da instituição Binário Tech.

O projeto tem como objetivo realizar o gerenciamento de cursos e matrículas de alunos, utilizando Node.js, Express e MongoDB.

## 2. Tecnologias utilizadas

- Node.js
- Express
- JavaScript
- MongoDB
- Mongoose
- Docker
- Bash
- cURL
- jq

## 3. Funcionalidades

### 3.1 Cursos

- Cadastrar cursos.
- Listar cursos.
- Filtrar cursos por nome, categoria e status.
- Atualizar cursos.
- Excluir cursos.

### 3.2 Matrículas

- Cadastrar matrículas.
- Listar matrículas.
- Atualizar matrículas.
- Excluir matrículas.
- Vincular matrículas aos cursos cadastrados.

## 4. Estrutura do projeto

```text
binario_cursos/
├── src/
│   ├── config/
│   │   └── database.js
│   ├── controllers/
│   │   ├── cursoController.js
│   │   └── matriculaController.js
│   ├── models/
│   │   ├── Curso.js
│   │   └── Matricula.js
│   └── routes/
│       ├── cursoRoutes.js
│       └── matriculaRoutes.js
├── .env
├── .gitignore
├── package.json
├── package-lock.json
├── server.js
├── teste_cursos.sh
└── README.md
```

## 5. Instalação e configuração

### 5.1 Clonar o repositório

```bash
git clone https://github.com/Dusse0/binario_cursos.git
```

### 5.2 Acessar a pasta do projeto

```bash
cd binario_cursos
```

### 5.3 Instalar as dependências

```bash
npm install
```

### 5.4 Instalar o jq

```bash
sudo apt update
sudo apt install jq
```

### 5.5 Configurar as variáveis de ambiente

Criar o arquivo `.env`:

```bash
nano .env
```

Adicionar:

```env
PORT=1129
MONGO_URI=mongodb://127.0.0.1:27017/binario_cursos_nosql
```

## 6. Configuração do MongoDB

O projeto utiliza MongoDB em um container Docker.

### 6.1 Criar o container

```bash
docker run -d \
  --name mongodb-binario \
  -p 27017:27017 \
  -v mongodb_binario_data:/data/db \
  mongo:7
```

### 6.2 Iniciar o container existente

```bash
docker start mongodb-binario
```

### 6.3 Verificar o container

```bash
docker ps
```

## 7. Inicialização da API

Iniciar o servidor:

```bash
npm start
```

Ou utilizar o modo de desenvolvimento:

```bash
npm run dev
```

A API estará disponível em:

```text
http://localhost:1129
```

## 8. Rotas da API

### 8.1 Cursos

| Método | Rota | Descrição |
|---|---|---|
| POST | `/cursos` | Cadastrar curso |
| GET | `/cursos` | Listar cursos |
| PATCH | `/cursos/:id` | Atualizar curso |
| DELETE | `/cursos/:id` | Excluir curso |

**Query Params disponíveis:**

- `nome`: filtra pelo nome.
- `categoria`: filtra pela categoria.
- `status`: filtra pelo status.

**Exemplo:**

```text
http://localhost:1129/cursos?categoria=Banco%20de%20Dados
```

### 8.2 Matrículas

| Método | Rota | Descrição |
|---|---|---|
| POST | `/matriculas` | Cadastrar matrícula |
| GET | `/matriculas` | Listar matrículas |
| PATCH | `/matriculas/:id` | Atualizar matrícula |
| DELETE | `/matriculas/:id` | Excluir matrícula |

## 9. Comandos para testar a API

### 9.1 Cadastrar cursos

**Curso do Felipe:**

```bash
curl -X POST http://localhost:1129/cursos \
-H "Content-Type: application/json" \
-d '{"nome":"Desenvolvimento Back-End","descricao":"Introdução ao desenvolvimento de APIs","cargaHoraria":40,"categoria":"Programação","instrutor":"Felipe"}' | jq
```

**Curso do Myguel:**

```bash
curl -X POST http://localhost:1129/cursos \
-H "Content-Type: application/json" \
-d '{"nome":"Banco de Dados com MongoDB","descricao":"Introdução aos bancos NoSQL","cargaHoraria":30,"categoria":"Banco de Dados","instrutor":"Myguel"}' | jq
```

### 9.2 Consultar cursos

**Listar todos:**

```bash
curl http://localhost:1129/cursos | jq
```

**Filtrar por nome:**

```bash
curl "http://localhost:1129/cursos?nome=MongoDB" | jq
```

**Filtrar por categoria:**

```bash
curl "http://localhost:1129/cursos?categoria=Programação" | jq
```

**Filtrar por status:**

```bash
curl "http://localhost:1129/cursos?status=Ativo" | jq
```

### 9.3 Atualizar e excluir cursos

**Atualizar:**

```bash
curl -X PATCH http://localhost:1129/cursos/ID_DO_CURSO \
-H "Content-Type: application/json" \
-d '{"status":"Inativo"}' | jq
```

**Excluir:**

```bash
curl -X DELETE http://localhost:1129/cursos/ID_DO_CURSO | jq
```

### 9.4 Cadastrar matrículas

**Matrícula do Felipe:**

```bash
curl -X POST http://localhost:1129/matriculas \
-H "Content-Type: application/json" \
-d '{"nomeAluno":"Felipe","emailAluno":"felipe@gmail.com","curso":"ID_DO_CURSO"}' | jq
```

**Matrícula do Myguel:**

```bash
curl -X POST http://localhost:1129/matriculas \
-H "Content-Type: application/json" \
-d '{"nomeAluno":"Myguel","emailAluno":"myguel@gmail.com","curso":"ID_DO_CURSO"}' | jq
```

### 9.5 Consultar matrículas

```bash
curl http://localhost:1129/matriculas | jq
```

### 9.6 Atualizar matrículas

**Atualizar matrícula do Myguel:**

```bash
curl -X PATCH http://localhost:1129/matriculas/6af5cbf4d45c5a903e1f6998 \
-H "Content-Type: application/json" \
-d '{"nomeAluno":"Myguel","status":"TRANCADA"}' | jq
```

**Atualizar matrícula do Felipe:**

```bash
curl -X PATCH http://localhost:1129/matriculas/6af5cbcbd45c5a903e1f6996 \
-H "Content-Type: application/json" \
-d '{"nomeAluno":"Felipe","status":"CONCLUIDA"}' | jq
```

### 9.7 Excluir matrícula

```bash
curl -X DELETE http://localhost:1129/matriculas/ID_DA_MATRICULA | jq
```

### 9.8 Testar erros

**Cadastro de curso sem dados (esperado: HTTP 400):**

```bash
curl -i -X POST http://localhost:1129/cursos \
-H "Content-Type: application/json" \
-d '{}'
```

**Atualização de curso inexistente (esperado: HTTP 404):**

```bash
curl -i -X PATCH http://localhost:1129/cursos/000000000000000000000000 \
-H "Content-Type: application/json" \
-d '{"status":"Inativo"}'
```

**Observação:** substitua `ID_DO_CURSO` e `ID_DA_MATRICULA` pelos identificadores reais retornados pela API. Os IDs das matrículas de Felipe e Myguel correspondem aos registros utilizados nos testes anteriores.

## 10. Testes automatizados

O projeto possui um script Bash chamado `teste_cursos.sh`, que automatiza as requisições utilizando cURL e jq.

**Executar os testes:**

```bash
bash teste_cursos.sh
```

**Gerar o arquivo de log:**

```bash
bash teste_cursos.sh > resultado_execucao.log 2>&1
```

**Visualizar o resultado:**

```bash
cat resultado_execucao.log
```

## 11. Códigos de resposta HTTP

| Código | Descrição |
|---|---|
| 200 | Requisição realizada com sucesso |
| 201 | Registro criado com sucesso |
| 400 | Dados inválidos ou erro na requisição |
| 404 | Registro não encontrado |
| 500 | Erro interno do servidor |

## 12. Banco de dados

O sistema utiliza MongoDB como banco de dados NoSQL e Mongoose para realizar a modelagem e comunicação com o banco.

São utilizadas duas coleções principais:

- **Cursos:** armazena as informações dos cursos cadastrados.
- **Matrículas:** armazena os dados dos alunos matriculados e a referência ao curso correspondente.

## 13. Autores

**Felipe Rosa da Silva**

**Myguel Dusse Luz Leal**

**Orientador:** Irineu Moura Caldeira

**Instituição:** Binário Tech

**Disciplina:** Programação Back-End 1 (PBE1)

**Projeto Final.**
