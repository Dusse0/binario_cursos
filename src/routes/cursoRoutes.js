const express = require('express');
const router = express.Router();
const cursoController = require('../controllers/cursoController');

router.post('/', cursoController.criarCurso);
router.get('/', cursoController.listarCursos);

module.exports = router;
