const Matricula = require('../models/Matricula');

const matriculaController = {

	// 1. Cria uma nova matricula de um aluno
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
	
	// 2. Lista as matriculas dos alunos
        listarMatriculas: async (req, res) => {
                try {
                        const matriculas = await Matricula.find().sort({ dataMatricula: -1 });
                        res.status(200).json(matriculas);
                } catch (erro) {
                        res.status(500).json({ erro: "Erro ao consultar coleção no MongoDB" });
                }
        },

	// 3. Possibilita atualizar a matricula de um aluno
        atualizarMatricula: async (req, res) => {
                try {
                        const { id } = req.params;
                        const { nomeAluno, emailAluno, curso, dataMatricula, status } = req.body;

                        const atualizado = await Matricula.findByIdAndUpdate(
                                id,
                                { nomeAluno, emailAluno, curso, dataMatricula, status },
                                { new: true, runValidators: true }
                        );

                        if(!atualizado) {
                                return res.status(404).json({ erro: "Matricula não encontrado."});
                        }

                        res.status(200).json(atualizado);
                } catch (erro) {
                        res.status(400).json({ erro: "Erro ao atualizar a matricula.", detalhe: erro.message });

                }
        },

	// 4. Deleta a matricula do aluno
        excluirMatricula: async (req, res) => {
                try {
                        const { id } = req.params;
                        const removido =  await Matricula.findByIdAndDelete(id);

                        if(!removido) {
                                return res.status(404).json({erro: "Matricula não encontrada para exclusão." });
                        }

                        res.status(200).json({ mensagem: "Matricula excluída com sucesso!" });
                } catch (erro) {
                        res.status(500).json({ erro: "Erro ao excluir a matricula." });
                }
        }
};

module.exports = matriculaController;
