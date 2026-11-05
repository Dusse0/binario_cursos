const  mongoose = require('mongoose');

const cursoSchema = new mongoose.Schema({
	nome: {
		type: String,
		required: [true, 'O nome do curso é obrigatório.']
	},
	descricao: {
		type: String,
		required: [true, 'A descricao é obrigatória.']
	},
	cargaHoraria: {
		type: Number,
		required: [true, 'A carga Horária e obrigatória.']
	},
	categoria: {
		type: String,
		required: [true, 'A categoria é obrigatória']
	},
	instrutor: {
		type: String,
		required: [true, 'O nome do instrutor  é obrigatório']
	},
	status: {
		type: String,
		enum: ['Ativo', 'Inativo'],
		default: 'Ativo'
	}
}, {
	timestamps: true
});

module.exports = mongoose.model('Curso', cursoSchema);
