const Matricula = require('../models/Matricula');

const matriculaController = {
	criarMatricula: async (req, res) => {
		try {
			const { nomeAluno, emailAluno, curso  } = req.body;

			const novaMatricula = await Matricula.create({
				nomeAluno,
				emailAluno,
				curso
			});

			res.status(201).json(novaMatricula);
		} catch (erro) {
			res.status(400).json({ erro: "Erro ao salvar a matricula no MongoDB", detalhe: erro.message });
		}
	},

	listarMatriculas: async (req, res) => {
		try {
			const matriculas = await Matricula.find().sort({ dataMatricula: -1 });
			res.status(200).json(matriculas);
		} catch (erro) {
			res.status(500).json({ erro: "Erro ao consultar coleção no MongoDB" });
		}
	}
};

module.exports = matriculaController;
