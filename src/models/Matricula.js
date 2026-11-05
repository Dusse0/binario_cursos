const mongoose = require('mongoose');

const matriculaSchema = new mongoose.Schema({
	nomeAluno: {
		type: String,
		required: [true, 'O nome é obrigatório.']
	},
	emailAluno: {
		type: String,
		required: [true, 'O email do aluno é obrigatório.']
	},
	curso: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'Curso',
		required: [true, 'O curso é obrigatório.']
	},
	dataMatricula: {
		type: Date,
		default: Date.now
	},
	status: {
		type: String,
		enum: ['ATIVA','TRANCADA','CANCELADA','SUSPENSA','CONCLUIDA'],
		default: 'ATIVA'
	}
}, {
	timestamps: true
});

module.exports = mongoose.model ('Matricula', matriculaSchema);
