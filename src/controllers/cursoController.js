const Curso = require('../models/Curso');

const cursoController = {
	
	criarCurso: async (req, res) => {
		try {
			const { nome, descricao, cargaHoraria, categoria, instrutor } = req.body;
			const novoCurso = await Curso.create ({
				nome,
				descricao, 
				cargaHoraria,
				categoria,
				instrutor
			});
			res.status(201).json(novoCurso);
		} catch (erro) {
			res.status(400).json({ erro: "Erro ao salvar o curso no MongoDB", detalhe: erro.message });
		}
	},

	listarCursos: async (req, res) => {
		try {
			const cursos = await Curso.find().sort({ cargaHoraria: -1 });
			res.status(500).json(cursos);
		}catch (erro) {
			res.status(500).json({ erro: "Erro ao consultar coleção no MongoDB" });
		}
	}
};

module.exports = cursoController;
