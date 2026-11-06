
const Curso = require('../models/Curso');

const cursoController = {

    criarCurso: async (req, res) => {
        try {
            const { nome, descricao, cargaHoraria, categoria, instrutor } = req.body;

            const novoCurso = await Curso.create({
                nome,
                descricao,
                cargaHoraria,
                categoria,
                instrutor
            });

            res.status(201).json(novoCurso);
        } catch (erro) {
            res.status(400).json({
                erro: "Erro ao salvar o curso no MongoDB",
                detalhe: erro.message
            });
        }
    },

    listarCursos: async (req, res) => {
        try {
            const { nome, categoria, status } = req.query;

            const filtros = {};

            if (nome) {
                filtros.nome = { $regex: nome, $options: 'i' };
            }

            if (categoria) {
                filtros.categoria = categoria;
            }

            if (status) {
                filtros.status = status;
            }

            const cursos = await Curso.find(filtros)
                .sort({ cargaHoraria: -1 });

            res.status(200).json(cursos);
        } catch (erro) {
            res.status(500).json({
                erro: "Erro ao consultar coleção no MongoDB"
            });
        }
    },

    atualizarCurso: async (req, res) => {
        try {
            const { id } = req.params;
            const { nome, descricao, cargaHoraria, categoria, instrutor, status } = req.body;

            const atualizado = await Curso.findByIdAndUpdate(
                id,
                { nome, descricao, cargaHoraria, categoria, instrutor, status },
                { new: true, runValidators: true }
            );

            if (!atualizado) {
                return res.status(404).json({ erro: "Curso não encontrado." });
            }

            res.status(200).json(atualizado);
        } catch (erro) {
            res.status(400).json({
                erro: "Erro ao atualizar o curso.",
                detalhe: erro.message
            });
        }
    },

    excluirCurso: async (req, res) => {
        try {
            const { id } = req.params;
            const removido = await Curso.findByIdAndDelete(id);

            if (!removido) {
                return res.status(404).json({
                    erro: "Curso não encontrado para exclusão."
                });
            }

            res.status(200).json({
                mensagem: "Curso excluído com sucesso!"
            });
        } catch {
            res.status(500).json({ erro: "Erro ao excluir o curso." });
        }
    }
};

module.exports = cursoController;

