class UsuarioModel {
  final int id;
  final String nome;
  final String email;
  final String senhaHash;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.senhaHash,
  });
}

// final = valor só pode ser atribuido uma vez, é imutável
// required = obriga que o construtor (parametro) seja informado na hora de criar o objeto
