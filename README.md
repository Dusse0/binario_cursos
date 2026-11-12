# BINÁRIO CURSOS

## 1. Apresentação

A Binário Cursos é uma API RESTful desenvolvida como projeto final da disciplina de Programação Back-End 1 (PBE1), da instituição Binário Tech.

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
- Git e GitHub

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
├── server.js
├── testes.sh
├── resultado_execucao.log
└── README.md
```

## 5. Instalação e configuração

### 5.1 Clonar o repositório

```bash
git clone https://github.com/Dusse0/FMT1DEV-T5.git
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

Adicionar as seguintes configurações:

```env
PORT=1129
MONGO_URI=mongodb://127.0.0.1:27017/binario_cursos_nosql
```

## 6. Configuração do MongoDB

O projeto utiliza MongoDB em um container Docker.

### 6.1 Criar e iniciar o container

```bash
docker run -d \
  --name mongodb-binario \
  -p 27017:27017 \
  -v mongodb_binario_data:/data/db \
  mongo:7
```

### 6.2 Iniciar o container novamente

Caso o container já tenha sido criado e esteja parado:

```bash
docker start mongodb-binario
```

### 6.3 Verificar os containers em execução

```bash
docker ps
```

## 7. Inicialização da API

Para iniciar o servidor:

```bash
npm start
```

Para iniciar em modo de desenvolvimento:

```bash
npm run dev
```

A API estará disponível no endereço:

```text
http://localhost:1129
```

## 8. Rotas da API

### 8.1 Rotas de Cursos

| Método HTTP | Rota | Descrição |
|---|---|---|
| POST | /cursos | Cadastrar um curso |
| GET | /cursos | Listar todos os cursos |
| PATCH | /cursos/:id | Atualizar um curso |
| DELETE | /cursos/:id | Excluir um curso |

#### Filtros disponíveis

A listagem de cursos permite utilizar os seguintes Query Params:

- `nome`: filtra pelo nome do curso.
- `categoria`: filtra pela categoria.
- `status`: filtra pelo status.

Exemplo:

```text
http://localhost:1129/cursos?categoria=Banco%20de%20Dados
```

### 8.2 Rotas de Matrículas

| Método HTTP | Rota | Descrição |
|---|---|---|
| POST | /matriculas | Cadastrar uma matrícula |
| GET | /matriculas | Listar todas as matrículas |
| PATCH | /matriculas/:id | Atualizar uma matrícula |
| DELETE | /matriculas/:id | Excluir uma matrícula |

## 9. Códigos de resposta HTTP

A API utiliza os seguintes códigos HTTP:

| Código | Descrição |
|---|---|
| 200 | Requisição realizada com sucesso |
| 201 | Registro criado com sucesso |
| 400 | Dados inválidos ou erro na requisição |
| 404 | Registro não encontrado |

## 10. Testes automatizados

O projeto possui um script Bash chamado `testes.sh`, desenvolvido para automatizar as requisições da API utilizando cURL e jq.

### 10.1 Dar permissão de execução

```bash
chmod +x testes.sh
```

### 10.2 Executar os testes e gerar o arquivo de log

```bash
./testes.sh > resultado_execucao.log 2>&1
```

### 10.3 Visualizar o resultado da execução

```bash
cat resultado_execucao.log
```

O arquivo `resultado_execucao.log` registra os resultados dos testes realizados nas rotas de Cursos e Matrículas.

## 11. Comandos Linux

Durante o desenvolvimento e gerenciamento da aplicação, foram utilizados comandos Linux.

### 11.1 Visualizar processos em execução

```bash
ps aux
```

### 11.2 Localizar o processo Node.js

```bash
ps aux | grep node
```

### 11.3 Encerrar um processo pelo PID

```bash
kill NUMERO_DO_PID
```

O PID corresponde ao identificador do processo que será encerrado.

## 12. Comandos Git e GitHub

Comandos utilizados para controlar as versões do projeto e compartilhar alterações no repositório.

### 12.1 Verificar alterações

```bash
git status
```

### 12.2 Adicionar arquivos

```bash
git add .
```

### 12.3 Criar um commit

```bash
git commit -m "Descrição das alterações"
```

### 12.4 Enviar alterações para o GitHub

```bash
git push origin main
```

### 12.5 Atualizar o repositório local

```bash
git pull origin main
```

## 13. Banco de dados

O sistema utiliza MongoDB como banco de dados NoSQL e Mongoose para realizar a modelagem e comunicação com o banco.

São utilizadas duas coleções principais:

- **Cursos:** armazena as informações dos cursos cadastrados.
- **Matrículas:** armazena os dados dos alunos matriculados e a referência ao curso correspondente.

## 14. Autores

**Felipe Rosa da Silva**

**Myguel Dusse Luz Leal**

## 15. Instituição

**Binário Tech**

Disciplina: Programação Back-End 1 (PBE1).

Projeto Final.
