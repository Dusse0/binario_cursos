const mongoose = require('mongoose');

const conectarBanco = async () => {
	try {
		const uri = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/binario_cursos_nosql'
		await mongoose.connect(uri);
		console.log('[Binário Cursos] MongoDB conectado com sucesso!');
	} catch (erro) {
		console.error(`[ERRO MONGODB]: Falha ao conectar ao banco - ${erro.message}`);
		process.exit(1);
  }
};

module.exports = conectarBanco;
