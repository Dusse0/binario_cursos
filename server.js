require('dotenv').config();

const express = require('express');
const cors = require('cors');
const conectarBanco = require('./src/config/database');

const cursoRoutes = require('./src/routes/cursoRoutes');
const matriculasRoutes = require('./src/routes/matriculaRoutes');

const app = express();
const PORT = process.env.PORT || 1129;

// Middlewares
app.use(cors());
app.use(express.json());

// Rotas
app.use('/cursos', cursoRoutes);
app.use('/matriculas', matriculasRoutes);

conectarBanco().then(() => {
    app.listen(PORT, () => {
        console.log(`[Binario Cursos] Servidor rodando na porta ${PORT}`);
    });
});

