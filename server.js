require('dotenv').config();

const express = require('express');
const cors = require('cors');
const conectarBanco = require('./src/config/database');
const cursoRoutes = require('./src/routes/cursoRoutes');
const matriculasRoutes = require('./src/routes/matriculaRoutes');

const app = express();
const PORT = process.env.PORT || 1129;

// [FLUXO] Middlewares de entrada de dados
app.use(cors());
app.use(express.json());

// [FLUXO] Rotas da API
app.use('/cursos', cursoRoutes);
app.use('/matriculas', matriculasRoutes);

// [FLUXO] Conecta ao banco e inicia o servidor
conectarBanco()
	.then(() => {
		app.listen(PORT, () => {
            		console.log(`[Binario Cursos] Servidor rodando na porta ${PORT}`);
        });
    })
	.catch((erro) => {
	// [ERRO] Falha ao conectar ou iniciar a aplicação
		console.error('[ERRO] Falha ao conectar ao banco:', erro.message);
		process.exit(1);
});
