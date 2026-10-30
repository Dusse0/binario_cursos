require('dotenv').config();

const express = require('express');
const cors = require('cors');
const conectarBanco = require('./src/config/database');

const app = express();
const PORT = process.env.PORT || 1129;

app.use(cors());
app.use(express.json());

conectarBanco().then(() => {
    app.listen(PORT, () => {
        console.log(`[Binario Cursos] Servidor rodando na porta ${PORT}`);
    });
});
