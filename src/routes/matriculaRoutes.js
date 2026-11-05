const express = require('express');
const router = express.Router();
const matriculaController = require('../controllers/matriculaController');

router.post('/', matriculaController.criarMatricula);
router.get('/', matriculaController.listarMatriculas);

module.exports = router;
