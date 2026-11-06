const express = require('express');
const router = express.Router();
const matriculaController = require('../controllers/matriculaController');

router.post('/', matriculaController.criarMatricula);
router.get('/', matriculaController.listarMatriculas);
router.patch('/:id', matriculaController.atualizarMatricula);
router.delete('/:id', matriculaController.excluirMatricula);

module.exports = router;
